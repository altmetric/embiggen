Gem::Specification.new do |s|
  s.name = 'embiggener'
  s.summary = 'A library to expand shortened URLs'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.authors = ['Paul Mucur']
  s.homepage = 'https://github.com/altmetric/embiggener'
  s.files = %w(lib/embiggener.rb lib/embiggener/uri.rb)
  s.test_files = %w(
    spec/spec_helper.rb
    spec/embiggener_spec.rb
    spec/embiggener/uri_spec.rb
  )

  s.add_development_dependency('rspec', '~> 3.2')
  s.add_development_dependency('webmock', '~> 1.21')
end
