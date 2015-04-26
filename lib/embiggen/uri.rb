require 'embiggen/embiggened_uri'
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
      return EmbiggenedURI.success(uri) if expanded?

      follow_redirects(request_options)
    rescue ::StandardError, ::Timeout::Error => e
      EmbiggenedURI.failure(uri, e)
    end

    alias_method :embiggen, :expand

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
      return EmbiggenedURI.too_many_redirects(uri) if redirects.zero?

      head_location(request_options).
        expand(request_options.merge(:redirects => redirects - 1))
    end

    def head_location(request_options = {})
      timeout = request_options.fetch(:timeout) { Configuration.timeout }

      http.open_timeout = timeout
      http.read_timeout = timeout

      extract_location(http.head(uri.request_uri))
    end

    def http
      http = ::Net::HTTP.new(uri.host, uri.inferred_port)
      http.use_ssl = true if uri.scheme == 'https'

      http
    end

    def extract_location(response)
      if response.is_a?(::Net::HTTPRedirection)
        URI.new(response.fetch('Location'))
      else
        EmptyLocation.new(uri)
      end
    end

    EmptyLocation = Struct.new(:uri) do
      def expand(_request_options = {})
        EmbiggenedURI.bad_shortened_uri(uri)
      end
    end
  end
end
