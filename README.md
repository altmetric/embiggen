# Embiggen [![Build Status](https://travis-ci.org/altmetric/embiggen.svg?branch=master)](https://travis-ci.org/altmetric/embiggen)

A Ruby library to expand shortened URLs.

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

# Optionally specify a timeout in seconds for expansion
Embiggen::URI('https://youtu.be/dQw4w9WgXcQ').expand(:timeout => 5)
```

## Acknowledgements

* The list of shorteners comes from [LongURL.org's curated
  list](http://longurl.org/services).

## License

Copyright © 2015 Altmetric LLP

Distributed under the MIT License.
