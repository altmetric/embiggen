require 'embiggen/error'
require 'net/http'

module Embiggen
  class HttpClient
    attr_reader :uri, :http

    def initialize(uri)
      @uri = uri
      @http = ::Net::HTTP.new(uri.host, uri.port)
      @http.use_ssl = true if uri.scheme == 'https'
    end

    def follow(timeout)
      response = request(timeout)
      return unless response.is_a?(::Net::HTTPRedirection)

      response.fetch('Location')
    rescue StandardError, ::Timeout::Error => e
      raise NetworkError.new(
        "could not follow #{uri}: #{e.message}", uri)
    end

    private

    def request(timeout)
      http.open_timeout = timeout
      http.read_timeout = timeout

      http.get(uri.request_uri)
    end
  end
end
