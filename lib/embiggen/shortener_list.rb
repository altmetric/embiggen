require 'forwardable'
require 'set'

module Embiggen
  class ShortenerList
    extend Forwardable
    extend Enumerable

    attr_reader :domains

    def initialize(domains)
      @domains = Set.new(domains)
    end

    def include?(uri)
      domains.any? { |domain| uri.host =~ /\b#{domain}\z/i }
    end

    def +(other)
      self.class.new(domains + other)
    end

    def_delegators :domains, :<<, :size, :delete, :empty?, :each
  end
end
