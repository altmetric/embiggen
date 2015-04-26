# Embiggen [![Build Status](https://travis-ci.org/altmetric/embiggen.svg?branch=master)](https://travis-ci.org/altmetric/embiggen)

**This branch describes the unreleased 1.x version of Embiggen, see the
[master branch](https://github.com/altmetric/embiggen) for the current stable
version.**

A Ruby library to expand shortened URLs.

**Current version:** 0.1.1  
**Supported Ruby versions:** 1.8.7, 1.9.2, 1.9.3, 2.0, 2.1, 2.2

## Installation

```
gem install embiggen -v '~> 0.1'
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
#=> #<Embiggen::EmbiggenedURI https://www.youtube.com/watch?v=dQw4w9WgXcQ&f...>

# EmbiggenedURIs can be used much like Addressable::URIs
uri.to_s
#=> 'https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be'
uri.host
#=> 'www.youtube.com'
uri.inferred_port
#=> 443
uri.path
#=> '/watch'
uri.query
#=> 'v=dQw4w9WgXcQ&feature=youtu.be'
uri.request_uri
#=> '/watch?v=dQw4w9WgXcQ&feature=youtu.be'
uri.scheme
#=> 'https'

# Or you can get an actual Addressable::URI instance out of them
uri.uri
#=> #<Addressable::URI URI:https://www.youtube.com/watch?v=dQw4w9WgXcQ&feat...>

# You can interrogate them to see if they expanded successfully
uri.success?
#=> true

# If there weren't successful, you can ask them why
uri.success?
#=> false
uri.error
#=> #<Embiggen::TooManyRedirects ...>
# or
#=> #<Embiggen::BadShortenedURI ...>
# or
#=> #<Timeout::Error ...>

# Before expansion, you can check whether a URI is shortened or not
Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').shortened?
#=> true

# Gracefully deals with unshortened URIs
uri = Embiggen::URI('http://www.altmetric.com/')
uri.shortened?
#=> false
uri.expand
#=> #<Embiggen::EmbiggenedURI http://www.altmetric.com/>

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

Takes instances of [`Addressable::URI`][URI] or anything with a string
representation (through `to_s`) that can be parsed as a valid URI.

### `Embiggen::URI#expand`

```ruby
Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').expand
#=> #<Embiggen::EmbiggenedURI https://www.youtube.com/watch?v=dQw4w9WgXcQ&f...>

Embiggen::URI('http://www.altmetric.com/').expand
#=> #<Embiggen::EmbiggenedURI http://www.altmetric.com/>

Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').expand(:timeout => 5)
Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').expand(:redirects => 2)
```

Expand the given URI, returning the result as an `Embiggen::EmbiggenedURI`.
Will not raise any exceptions thrown during expansion (e.g. timeouts, network
errors, invalid return URIs) but will encapsulate any error within the result
(c.f. [`Embiggen::EmbiggenedURI#error`](#embiggenembiggenedurierror)).

Takes an optional hash of options for expansion:

* `:timeout`: overrides the default timeout for following redirects;
* `:redirects`: overrides the default number of redirects to follow.

Uses a whitelist of shortening domains (as configured through
[`Embiggen.configure`](#embiggenconfigure)) to determine whether a URI is
shortened or not. Be sure to [configure this to suit your needs](#shorteners).

### `Embiggen::URI#shortened?`

```ruby
Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').shortened?
#=> true

Embiggen::URI('http://www.altmetric.com').shortened?
#=> false
```

Return true if the URI appears to be shortened. Uses the configured whitelist
of shorteners, c.f. [Shorteners](#shorteners).

### `Embiggen::URI#expanded?`

```ruby
Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').expanded?
#=> false

Embiggen::URI('http://www.altmetric.com').expanded?
#=> true
```

The opposite of [`Embiggen::URI#shortened?`](#embiggenurishortened).

### `Embiggen::EmbiggenedURI#success?`

```ruby
uri = Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').expand
uri.success?
#=> true
```

Return true if the URI was expanded successfully.

### `Embiggen::EmbiggenedURI#error`

```ruby
uri = Embiggen::URI('http://bit.ly/some-bad-link').expand
uri.success?
#=> false
uri.error
#=> #<Timeout::Error ...>
```

Return any error raised during expansion (e.g. timeouts, network errors,
invalid URIs).

### `Embiggen::EmbiggenedURI#to_s`

```ruby
Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').expand.to_s
#=> 'https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be'
```

Return the URI as a string.

### `Embiggen::EmbiggenedURI#uri`

```ruby
Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').expand.uri
#=> #<Addressable::URI URI:https://www.youtube.com/watch?v=dQw4w9WgXcQ&feat...>
```

Return the underlying [`Addressable::URI`][URI] instance.

### `Embiggen::EmbiggenedURI#fragment`

```ruby
Embiggen::URI('http://www.altmetric.com/#foo').expand.fragment
#=> 'foo'
```

Return the fragment of the URI.

### `Embiggen::EmbiggenedURI#host`

```ruby
Embiggen::URI('http://www.altmetric.com/#foo').expand.host
#=> 'www.altmetric.com'
```

Return the host of the URI.

### `Embiggen::EmbiggenedURI#path`

```ruby
Embiggen::URI('http://www.altmetric.com/#foo').expand.path
#=> '/'
```

Return the path of the URI.

### `Embiggen::EmbiggenedURI#inferred_port`

```ruby
Embiggen::URI('http://www.altmetric.com/#foo').expand.inferred_port
#=> 80
```

Return the port of the URI, falling back to the scheme defaults (e.g. 80 for
HTTP, 443 for HTTPS) if it isn't explicitly specified in the URI.

### `Embiggen::EmbiggenedURI#query`

```ruby
Embiggen::URI('http://www.altmetric.com/?foo=bar').expand.query
#=> 'foo=bar'
```

Return the query string of the URI.

### `Embiggen::EmbiggenedURI#scheme`

```ruby
Embiggen::URI('http://www.altmetric.com/?foo=bar').expand.scheme
#=> 'http'
```

Return the scheme of the URI.

### `Embiggen::EmbiggenedURI#request_uri`

```ruby
Embiggen::URI('http://www.altmetric.com/?foo=bar').expand.request_uri
#=> '/?foo=bar'
```

Return the full path, query string and fragment of the URI.

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

[URI]: http://addressable.rubyforge.org/api/Addressable/URI.html
