require 'embiggen/error'
require 'net/http'
require 'nokogiri'

module Embiggen
  class HtmlClient
    attr_reader :uri

    def initialize(uri)
      @uri = uri
      @http = ::Net::HTTP.new(uri.host, uri.port)
      @http.use_ssl = true if uri.scheme == 'https'
    end

    def follow(timeout, selector)
      response = request(timeout)
      return unless response.is_a?(::Net::HTTPOK)

      document = Nokogiri::HTML(response.body)
      element = document.at_css(selector)
      element&.[]('href')
    rescue ::Timeout::Error => e
      raise NetworkError.new(
        "Timeout::Error: could not follow #{uri}: #{e.message}", uri
      )
    rescue StandardError => e
      raise NetworkError.new(
        "StandardError: could not follow #{uri}: #{e.message}", uri
      )
    end

    private

    def request(timeout)
      request = ::Net::HTTP::Get.new(uri.request_uri)
      @http.open_timeout = timeout
      @http.read_timeout = timeout

      @http.request(request)
    end
  end
end
