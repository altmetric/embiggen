# Embiggen [![Build Status](https://travis-ci.org/altmetric/embiggen.svg?branch=master)](https://travis-ci.org/altmetric/embiggen)

**This branch describes the unreleased 1.x version of Embiggen, see the
[master branch](https://github.com/altmetric/embiggen) for the current stable
version.**

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
Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').expand
#=> #<URI:HTTPS https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be>

# Longer-form usage
uri = Embiggen::URI.new(URI('https://youtu.be/dQw4w9WgXcQ'))
uri.shortened?
#=> true
uri.expand
#=> #<URI:HTTPS https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be>

# Gracefully deals with unshortened URIs
uri = Embiggen::URI('http://www.altmetric.com')
uri.shortened?
#=> false
uri.expand
#=> #<URI:HTTP http://www.altmetric.com>

# Noisier expand! for explicit error handling
Embiggen::URI('http://bit.ly/bad').expand!
#=> TooManyRedirects: http://bit.ly/bad redirected too many times
# or...
#=> BadShortenedURI: following http://bit.ly/bad did not redirect

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
