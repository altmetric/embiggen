module Embiggen
  class NonRedirectShortenerList
    attr_reader :domains

    def initialize(domains)
      @domains = domains.to_h.transform_keys { |domain| host_pattern(domain) }
    end

    def supported?(uri)
      !selector_for(uri).nil?
    end

    def selector_for(uri)
      _, selector = domains.find { |pattern, _| uri.host =~ pattern }
      selector
    end

    def []=(domain, selector)
      domains[host_pattern(domain)] = selector
    end

    def delete(domain)
      domains.delete(host_pattern(domain))
    end

    def clear
      domains.clear
      self
    end

    def size
      domains.size
    end

    private

    def host_pattern(domain)
      /\b#{Regexp.escape(domain)}\z/i
    end
  end
end
