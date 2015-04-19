require 'embiggen/embiggened_uri'
require 'embiggen/configuration'
require 'net/http'

module Embiggen
  class URI
    attr_reader :uri

    def initialize(uri)
      @uri = uri.is_a?(::URI::Generic) ? uri : URI(uri.to_s)
    end

    def expand(request_options = {})
      return EmbiggenedURI.success(uri) if expanded?

      follow_redirects(request_options)
    rescue ::Timeout::Error, ::Errno::ECONNRESET => e
      EmbiggenedURI.failure(uri, e.message)
    end

    def expand!(request_options = {})
      warn 'DEPRECATION WARNING: expand! is deprecated in favour of expand'
      return EmbiggenedURI.success(uri) if expanded?

      follow_redirects!(request_options)
    end

    def shortened?
      Configuration.shorteners.any? { |domain| uri.host =~ /\b#{domain}\z/i }
    end

    def expanded?
      !shortened?
    end

    def inspect
      "#<#{self.class} #{uri}>"
    end

    private

    def follow_redirects(request_options = {})
      redirects = request_options.fetch(:redirects) { Configuration.redirects }
      return EmbiggenedURI.failure(uri) if redirects.zero?

      location = head_location(request_options)
      return EmbiggenedURI.failure(uri, "following #{uri} did not " \
                                        'redirect') unless location

      location.expand(request_options.merge(:redirects => redirects - 1))
    end

    def follow_redirects!(request_options = {})
      redirects = request_options.fetch(:redirects) { Configuration.redirects }
      fail TooManyRedirects, "#{uri} redirected too many " \
                             'times' if redirects.zero?

      location = head_location(request_options)
      fail BadShortenedURI, "following #{uri} did not " \
                            'redirect' unless location

      location.expand!(request_options.merge(:redirects => redirects - 1))
    end

    def head_location(request_options = {})
      timeout = request_options.fetch(:timeout) { Configuration.timeout }

      http.open_timeout = timeout
      http.read_timeout = timeout

      response = http.head(uri.request_uri)

      URI.new(
        response.fetch('Location')) if response.is_a?(::Net::HTTPRedirection)
    end

    def http
      http = ::Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'

      http
    end
  end

  class Error < ::StandardError; end
  class BadShortenedURI < Error; end
  class TooManyRedirects < Error; end
end
