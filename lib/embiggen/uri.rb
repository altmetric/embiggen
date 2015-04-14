require 'embiggen/configuration'
require 'net/http'

module Embiggen
  class URI
    attr_reader :uri

    def initialize(uri)
      @uri = if uri.is_a?(::URI::Generic)
               uri
             else
               ::URI.parse(uri.to_s)
             end
    end

    def expand(request_options = {})
      redirects = request_options.fetch(:redirects) { Configuration.redirects }
      return uri if !shortened? || redirects.zero?

      location = head_location(request_options)
      return uri unless location

      URI.new(location).
        expand(request_options.merge(:redirects => redirects - 1))
    rescue ::Timeout::Error, ::Errno::ECONNRESET
      uri
    end

    def shortened?
      Configuration.shorteners.any? { |domain| uri.host =~ /\b#{domain}\z/i }
    end

    private

    def head_location(request_options = {})
      timeout = request_options.fetch(:timeout) { Configuration.timeout }

      http.open_timeout = timeout
      http.read_timeout = timeout

      response = http.head(uri.request_uri)

      response.fetch('Location') if response.is_a?(::Net::HTTPRedirection)
    end

    def http
      http = ::Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'

      http
    end
  end
end
