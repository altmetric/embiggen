require 'embiggen/configuration'
require 'embiggen/uri'

module Embiggen
  def URI(uri)
    uri.is_a?(URI) ? uri : URI.new(uri)
  end

  def configure
    yield(Configuration)
  end

  module_function :URI, :configure
end
