# encoding: utf-8
require 'set'
require 'embiggen/shortener_list'

module Embiggen
  class Configuration
    class << self
      attr_writer :timeout, :redirects, :shorteners
    end

    def self.timeout
      @timeout ||= 1
    end

    def self.redirects
      @redirects ||= 5
    end

    # From http://longurl.org/services
    def self.shorteners
      @shorteners ||= ShortenerList.new(shorteners_from_file)
    end

    def self.shorteners_from_file
      file_path = File.expand_path('../../shorteners.txt', __dir__)
      File.readlines(file_path).map(&:chomp)
    end
  end
end
