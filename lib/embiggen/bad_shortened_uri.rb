require 'embiggen/error'

module Embiggen
  class BadShortenedURI < Error
    def self.for(uri)
      new("following #{uri} did not redirect")
    end
  end
end
