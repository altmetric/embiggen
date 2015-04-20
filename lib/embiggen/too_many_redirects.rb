require 'embiggen/error'

module Embiggen
  class TooManyRedirects < Error
    def self.for(uri)
      new("#{uri} redirected too many times")
    end
  end
end
