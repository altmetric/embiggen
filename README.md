# Embiggen [![Build Status](https://travis-ci.org/altmetric/embiggen.svg?branch=master)](https://travis-ci.org/altmetric/embiggen)

A Ruby library to expand shortened URLs.

**Current version:** 0.2.0  
**Supported Ruby versions:** 1.8.7, 1.9.2, 1.9.3, 2.0, 2.1, 2.2

## Installation

```
gem install embiggen -v '~> 0.2'
```

Or, in your `Gemfile`:

```ruby
gem 'embiggen', '~> 0.2'
```

## Usage

```ruby
require 'embiggen'

# Basic usage
Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').expand
#=> #<URI::HTTPS https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be>

# Longer-form usage
uri = Embiggen::URI.new(URI('https://youtu.be/dQw4w9WgXcQ'))
uri.shortened?
#=> true
uri.expand
#=> #<URI::HTTPS https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be>

# Gracefully deals with unshortened URIs
uri = Embiggen::URI('http://www.altmetric.com')
uri.shortened?
#=> false
uri.expand
#=> #<URI::HTTP http://www.altmetric.com>

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

## API Documentation

### `Embiggen::URI`

```ruby
uri = Embiggen::URI('https://youtu.be/dQw4w9WgXcQ')
uri = Embiggen::URI(URI('https://youtu.be/dQw4w9WgXcQ'))
```

Return a new `Embiggen::URI` instance which can be expanded and asked whether
it is shortened or not.

Takes instances of [Ruby's
`URI`][URI] or
anything with a string representation (through `to_s`) that can be parsed as a
valid URI.

### `Embiggen::URI#expand`

```ruby
Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').expand
#=> #<URI::HTTPS https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be>

Embiggen::URI('http://www.altmetric.com/').expand
#=> #<URI::HTTP http://www.altmetric.com/>

Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').expand(:timeout => 5)
Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').expand(:redirects => 2)
```

Expand the given URI, returning the full version as a [`URI`][URI] if it is
shortened or the original if it cannot be expanded. Will not raise any
exceptions thrown during expansion (e.g. timeouts, network errors, invalid
return URIs); see `expand!` for an alternative.

Takes an optional hash of options for expansion:

* `:timeout`: overrides the default timeout for following redirects;
* `:redirects`: overrides the default number of redirects to follow.

Uses a whitelist of shortening domains (as configured through
`Embiggen.configure`) to determine whether a URI is shortened or not. Be sure
to [configure this to suit your needs](#shorteners).

### `Embiggen::URI#expand!`

```ruby
Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').expand!
#=> #<URI::HTTPS https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be>

Embiggen::URI('http://bit.ly/some-bad-link').expand!
# TooManyRedirects: http://bit.ly/some-bad-link redirected too many times
```

Expand the given URI as with `Embiggen::URI#expand` but don't suppress any
exceptions raised during expansion (including timeouts, network errors,
invalid return URIs, too many redirects or no redirects whatsoever).

Takes the same options as `Embiggen::URI#expand`.

Two Embiggen-specific errors (both inheriting from `Embiggen::Error`) can be
raised:

* `Embiggen::TooManyRedirects`: when a URI redirects more than the configured
  number of times;
* `Embiggen::BadShortenedURI`: when a URI appears to be shortened but
  following it does not result in a redirect.

### `Embiggen::URI#shortened?`

```ruby
Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').shortened?
#=> true

Embiggen::URI('http://www.altmetric.com').shortened?
#=> false
```

Return true if the URI appears to be shortened. Uses the configured whitelist
of shorteners, c.f. [Shorteners](#shorteners).

### `Embiggen.configure`

```ruby
Embiggen.configure do |config|
  config.timeout = 5
  config.redirects = 2
  config.shorteners += %w(myshorten.er anoth.er)
end
```

Override the following settings:

* `timeout`: the default timeout for following any redirects (can be
  overridden by passing options to `Embiggen::URI#expand` or
  `Embiggen::URI#expand!`);
* `redirects`: the default number of redirects to follow (can be overridden by
  passing options to `Embiggen::URI#expand` or `Embiggen::URI#expand!`);
* `shorteners`: the list of domains of shortening services, c.f.
  [Shorteners](#shorteners).

## Acknowledgements

* The default list of shorteners comes from [LongURL.org's curated
  list](http://longurl.org/services).

## License

Copyright © 2015 Altmetric LLP

Distributed under the MIT License.

[URI]: http://ruby-doc.org/stdlib/libdoc/uri/rdoc/URI.html
