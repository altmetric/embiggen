# Embiggen [![Build Status](https://travis-ci.org/altmetric/embiggen.svg?branch=master)](https://travis-ci.org/altmetric/embiggen)

A Ruby library to expand shortened URLs.

## Usage
```ruby
require 'embiggen/uri'

uri = Embiggen::URI.new(URI('https://youtu.be/dQw4w9WgXcQ'))
uri.shortened?
# => true
uri.expand
# => 'https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be'

uri = Embiggen::URI.new(URI('http://www.altmetric.com'))
uri.shortened?
# => false
uri.expand
#=> 'http://www.altmetric.com'
```

## Acknowledgements

* The list of shorteners comes from [LongURL.org's curated
  list](http://longurl.org/services).

## License

Copyright © 2015 Altmetric LLP

Distributed under the MIT License.
