require 'delegate'

module Embiggen
  class EmbiggenedURI < SimpleDelegator
    attr_reader :success, :reason
    alias_method :success?, :success

    def self.success(uri)
      new(uri, :success => true)
    end

    def self.failure(uri, reason = nil)
      new(uri, :success => false, :reason => reason)
    end

    def initialize(uri, options = {})
      super(uri)
      @success = options.fetch(:success)
      @reason = options[:reason]
    end

    def inspect
      "#<#{self.class} #{self}>"
    end
  end
end
