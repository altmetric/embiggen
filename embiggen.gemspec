Gem::Specification.new do |s|
  s.name = 'embiggen'
  s.version = '1.7.1'
  s.summary = 'A library to expand shortened URLs'
  s.description = <<-EOF
    A library to expand shortened URIs, respecting timeouts, following
    multiple redirects and leaving unshortened URIs intact.
  EOF
  s.license = 'MIT'
  s.authors = ['Paul Mucur', 'Jonathan Hernandez']
  s.email = 'support@altmetric.com'
  s.homepage = 'https://github.com/altmetric/embiggen'
  s.files = %w[README.md LICENSE shorteners.txt] + Dir['lib/**/*.rb']
  s.test_files = Dir['spec/**/*.rb']

  s.add_dependency('addressable', '~> 2.3')

  s.add_development_dependency('rspec')
  s.add_development_dependency('webmock')
  s.add_development_dependency('rake')
  s.add_development_dependency('house_style')
end
