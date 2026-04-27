require 'forwardable'
require 'set'

module Embiggen
  class ShortenerList
    extend Forwardable
    include Enumerable

    attr_reader :domains

    def initialize(domains)
      @domains = Set.new(domains.map { |domain| host_pattern(domain) })
    end

    def include?(uri)
      domains.any? { |domain| uri.host =~ domain }
    end

    def +(other)
      self.class.new(domains + other)
    end

    def <<(domain)
      domains << host_pattern(domain)

      self
    end

    def delete(domain)
      domains.delete(host_pattern(domain))
    end

    def_delegators :domains, :size, :empty?, :each

    def host_pattern(domain)
      /\b#{domain}\z/i
    end
  end
end
