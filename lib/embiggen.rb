require 'embiggen/configuration'
require 'embiggen/uri'

module Embiggen
  def URI(uri)
    if uri.is_a?(URI)
      uri
    else
      URI.new(uri)
    end
  end

  def configure
    yield(Configuration)
  end

  module_function :URI, :configure
end
