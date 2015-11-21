require 'embiggen/configuration'
require 'embiggen/error'
require 'embiggen/http_client'
require 'addressable/uri'
require 'uri'

module Embiggen
  class URI
    attr_reader :uri, :http_client

    def initialize(uri)
      @uri = URI(::Addressable::URI.parse(uri).normalize.to_s)
      @http_client = HttpClient.new(@uri)
    end

    def expand(request_options = {})
      return uri unless shortened?

      redirects = extract_redirects(request_options)
      location = follow(request_options)

      self.class.new(location).
        expand(request_options.merge(:redirects => redirects - 1))
    end

    def shortened?
      Configuration.shorteners.any? { |domain| uri.host =~ /\b#{domain}\z/i }
    end

    private

    def extract_redirects(request_options = {})
      redirects = request_options.fetch(:redirects) { Configuration.redirects }
      fail TooManyRedirects.new(
        "following #{uri} reached the redirect limit", uri) if redirects.zero?

      redirects
    end

    def follow(request_options = {})
      timeout = request_options.fetch(:timeout) { Configuration.timeout }

      location = http_client.follow(timeout)
      fail BadShortenedURI.new(
        "following #{uri} did not redirect", uri) unless followable?(location)

      location
    end

    def followable?(location)
      return unless location

      Addressable::URI.parse(location).absolute?
    rescue Addressable::URI::InvalidURIError => e
      raise BadShortenedURI.new(
        "following #{uri} returns an invalid URI: #{e}", uri)
    end
  end
end
