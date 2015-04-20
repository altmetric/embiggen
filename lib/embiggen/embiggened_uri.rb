require 'forwardable'

module Embiggen
  class EmbiggenedURI
    extend Forwardable
    attr_reader :uri, :success, :error
    alias_method :success?, :success
    def_delegators :uri, :to_s, :fragment, :host, :path, :port, :query,
                   :scheme, :request_uri

    def self.success(uri)
      new(uri, :success => true)
    end

    def self.failure(uri, error = nil)
      new(uri, :success => false, :error => error)
    end

    def initialize(uri, options = {})
      @uri = uri
      @success = options.fetch(:success) { !options.key?(:error) }
      @error = options[:error]
    end

    def inspect
      "#<#{self.class} #{self}>"
    end
  end
end
