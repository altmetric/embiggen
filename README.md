# Embiggen [![Build Status](https://travis-ci.org/altmetric/embiggen.svg?branch=master)](https://travis-ci.org/altmetric/embiggen)

A Ruby library to expand shortened URLs.

**Current version:** 0.1.0  
**Supported Ruby versions:** 1.8.7, 1.9.2, 1.9.3, 2.0, 2.1, 2.2

## Installation

```
gem install embiggen
```

Or, in your `Gemfile`:

```ruby
gem 'embiggen', '~> 0.1'
```

## Usage
```ruby
require 'embiggen'

# Basic usage
uri = Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').expand
#=> #<Embiggen::EmbiggenedURI https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be>

# EmbiggenedURIs can be used much like standard URIs
uri.to_s
#=> 'https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be'
uri.host
#=> 'www.youtube.com'
uri.path
#=> '/watch'
uri.query
#=> 'v=dQw4w9WgXcQ&feature=youtu.be'
uri.request_uri
#=> '/watch?v=dQw4w9WgXcQ&feature=youtu.be'
uri.scheme
#=> 'https'

# Or you can get an actual standard library URI instance out of them
uri.uri
#=> #<URI::HTTPS https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be>

# You can interrogate them to see if they expanded successfully
uri.success?
#=> true

# If there weren't successful, you can ask them why
uri.success?
#=> false
uri.reason
#=> 'following https://youtu.be/dQw4w9WgXcQ did not redirect'
# or
#=> 'https://youtu.be/dQw4w9WgXcQ redirected too many times'

# Before expansion, you can check whether a URI is shortened or not
Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').shortened?
#=> true

# Gracefully deals with unshortened URIs
uri = Embiggen::URI('http://www.altmetric.com')
uri.shortened?
#=> false
uri.expand
#=> #<Embiggen::EmbiggenedURI http://www.altmetric.com>

# Optionally specify a timeout in seconds for expansion (default is 1)
Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').expand(:timeout => 5)

# Optionally specify a number of redirects to follow (default is 5)
Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').expand(:redirects => 2)

# Override the default configuration for all expansions and add your own
# shorteners
Embiggen.configure do |config|
  config.timeout = 5
  config.redirects = 2
  config.shorteners += %w(myshorten.er anoth.er)
end
```

## Shorteners

Embiggen ships with a default list of URL shortening service domains (c.f.
[Acknowledgements](#acknowledgements)) but as it is likely to be outdated and
incomplete, you are strongly encouraged to supply your own via
`Embiggen.configure`:

```ruby
Embiggen.configure do |config|
  config.shorteners = %w(myshorten.er anoth.er)
  # or load from a file...
  config.shorteners = File.readlines('shorteners.txt').map(&:chomp)
end
```

## Acknowledgements

* The default list of shorteners comes from [LongURL.org's curated
  list](http://longurl.org/services).

## License

Copyright © 2015 Altmetric LLP

Distributed under the MIT License.
