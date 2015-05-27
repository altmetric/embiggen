module Embiggen
  class Error < ::StandardError
    attr_reader :uri

    def initialize(message, uri)
      super(message)
      @uri = uri
    end
  end

  class BadShortenedURI < Error; end
  class NetworkError < Error; end
  class TooManyRedirects < Error; end
end
