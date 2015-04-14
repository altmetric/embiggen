module Embiggen
  class Configuration
    class << self
      attr_writer :timeout, :redirects
    end

    def self.timeout
      @timeout ||= 1
    end

    def self.redirects
      @redirects ||= 5
    end
  end
end
