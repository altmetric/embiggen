require 'embiggen/error'
require 'forwardable'

module Embiggen
  class EmbiggenedURI
    extend Forwardable
    attr_reader :uri, :success, :error
    alias_method :success?, :success
    def_delegators :uri, :to_s, :fragment, :host, :path, :inferred_port, :port,
                   :query, :scheme, :request_uri

    def self.too_many_redirects(uri)
      failure(uri, TooManyRedirects.for(uri))
    end

    def self.bad_shortened_uri(uri)
      failure(uri, BadShortenedURI.for(uri))
    end

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
