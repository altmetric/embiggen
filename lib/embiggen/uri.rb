require 'embiggen/embiggened_uri'
require 'embiggen/configuration'
require 'net/http'
require 'delegate'

module Embiggen
  class URI < SimpleDelegator
    def initialize(uri)
      super(uri.is_a?(::URI::Generic) ? uri : URI(uri.to_s))
    end

    def expand(request_options = {})
      return EmbiggenedURI.success(self) if expanded?

      follow_redirects(request_options)
    end

    def expand!(request_options = {})
      warn 'DEPRECATION WARNING: expand! is deprecated in favour of expand'
      return EmbiggenedURI.success(self) if expanded?

      follow_redirects!(request_options)
    end

    def shortened?
      Configuration.shorteners.any? { |domain| host =~ /\b#{domain}\z/i }
    end

    def expanded?
      !shortened?
    end

    def inspect
      "#<#{self.class} #{self}>"
    end

    private

    def follow_redirects(request_options = {})
      redirects = request_options.fetch(:redirects) { Configuration.redirects }
      return EmbiggenedURI.failure(self) if redirects.zero?

      location_uri(request_options).
        expand(request_options.merge(:redirects => redirects - 1))
    rescue ::Timeout::Error, ::Errno::ECONNRESET => e
      EmbiggenedURI.failure(self, e.message)
    end

    def follow_redirects!(request_options = {})
      redirects = request_options.fetch(:redirects) { Configuration.redirects }
      fail TooManyRedirects, "#{self} redirected too many " \
        'times' if redirects.zero?

      location = head_location(request_options)

      if location
        location.expand!(request_options.merge(:redirects => redirects - 1))
      else
        fail BadShortenedURI, "following #{self} did not redirect"
      end
    end

    def location_uri(request_options = {})
      location = head_location(request_options)

      if location
        EmbiggenedURI.success(location)
      else
        EmbiggenedURI.failure(self, "following #{self} did not redirect")
      end
    end

    def head_location(request_options = {})
      timeout = request_options.fetch(:timeout) { Configuration.timeout }

      http.open_timeout = timeout
      http.read_timeout = timeout

      response = http.head(request_uri)

      URI.new(
        response.fetch('Location')) if response.is_a?(::Net::HTTPRedirection)
    end

    def http
      http = ::Net::HTTP.new(host, port)
      http.use_ssl = true if scheme == 'https'

      http
    end
  end

  class Error < ::StandardError; end
  class BadShortenedURI < Error; end
  class TooManyRedirects < Error; end
end
