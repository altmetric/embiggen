Gem::Specification.new do |s|
  s.name = 'embiggen'
  s.summary = 'A library to expand shortened URLs'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.authors = ['Paul Mucur']
  s.homepage = 'https://github.com/altmetric/embiggen'
  s.files = %w(lib/embiggen.rb lib/embiggen/uri.rb)
  s.test_files = %w(
    spec/spec_helper.rb
    spec/embiggen_spec.rb
    spec/embiggen/uri_spec.rb
  )

  s.add_development_dependency('rspec', '~> 3.2')
  s.add_development_dependency('webmock', '~> 1.21')
end
