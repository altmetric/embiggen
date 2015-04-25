require 'embiggen/configuration'
require 'addressable/uri'
require 'net/http'

module Embiggen
  class URI
    attr_reader :uri

    def initialize(uri)
      @uri = ::Addressable::URI.parse(uri).normalize
    end

    def expand(request_options = {})
      expand!(request_options)
    rescue TooManyRedirects => error
      error.uri
    rescue Error, ::Timeout::Error, ::Errno::ECONNRESET
      uri
    end

    def expand!(request_options = {})
      return uri unless shortened?

      redirects = request_options.fetch(:redirects) { Configuration.redirects }
      check_redirects(redirects)

      location = head_location(request_options)
      check_location(location)

      URI.new(location).
        expand!(request_options.merge(:redirects => redirects - 1))
    end

    def shortened?
      Configuration.shorteners.any? { |domain| uri.host =~ /\b#{domain}\z/i }
    end

    private

    def check_redirects(redirects)
      return unless redirects.zero?

      fail TooManyRedirects.new("#{uri} redirected too many times", uri)
    end

    def check_location(location)
      return if location

      fail BadShortenedURI, "following #{uri} did not redirect"
    end

    def head_location(request_options = {})
      timeout = request_options.fetch(:timeout) { Configuration.timeout }

      http.open_timeout = timeout
      http.read_timeout = timeout

      response = http.head(uri.request_uri)

      response.fetch('Location') if response.is_a?(::Net::HTTPRedirection)
    end

    def http
      http = ::Net::HTTP.new(uri.host, uri.inferred_port)
      http.use_ssl = true if uri.scheme == 'https'

      http
    end
  end

  class Error < ::StandardError; end
  class BadShortenedURI < Error; end

  class TooManyRedirects < Error
    attr_reader :uri

    def initialize(message, uri)
      super(message)
      @uri = uri
    end
  end
end
