module Embiggen
  class Error < ::RuntimeError
  end

  class BadShortenedURI < Error
    def self.for(uri)
      new("following #{uri} did not redirect")
    end
  end

  class TooManyRedirects < Error
    def self.for(uri)
      new("#{uri} redirected too many times")
    end
  end
end
