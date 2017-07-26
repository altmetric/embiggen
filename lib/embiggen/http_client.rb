require 'embiggen/error'
require 'net/http'

module Embiggen
  class GetWithoutBody < ::Net::HTTPRequest
    METHOD = 'GET'.freeze
    REQUEST_HAS_BODY = false
    RESPONSE_HAS_BODY = false
  end

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
      request = GetWithoutBody.new(uri.request_uri)
      http.open_timeout = timeout
      http.read_timeout = timeout

      http.request(request)
    end
  end
end
