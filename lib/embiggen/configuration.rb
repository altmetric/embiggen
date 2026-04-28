# encoding: utf-8
require 'embiggen/shortener_list'
require 'embiggen/non_redirect_shortener_list'
require 'yaml'

module Embiggen
  class Configuration
    class << self
      attr_writer :timeout, :redirects, :shorteners, :non_redirect_shorteners
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

    def self.non_redirect_shorteners
      @non_redirect_shorteners ||= NonRedirectShortenerList.new(non_redirect_shorteners_from_file)
    end

    def self.non_redirect_shorteners_from_file
      file_path = File.expand_path('../../non_redirect_shorteners.yml', __dir__)
      YAML.safe_load(File.read(file_path))
    end
  end
end
