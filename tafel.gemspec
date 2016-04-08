
Gem::Specification.new do |s|

  s.name = 'tafel'

  s.version = File.read(
    File.expand_path('../lib/tafel.rb', __FILE__)
  ).match(/ VERSION *= *['"]([^'"]+)/)[1]

  s.platform = Gem::Platform::RUBY
  s.authors = [ 'John Mettraux' ]
  s.email = [ 'jmettraux@gmail.com' ]
  s.homepage = 'http://github.com/jmettraux/raabro'
  s.rubyforge_project = 'rufus'
  s.license = 'MIT'
  s.summary = 'something to turn data into an array of arrays'

  s.description = %{
Something to turn data (JSON) into an array of arrays (CSV)
  }.strip

  #s.files = `git ls-files`.split("\n")
  s.files = Dir[
    'Makefile',
    'lib/**/*.rb',# 'spec/**/*.rb', 'test/**/*.rb',
    '*.gemspec', '*.txt', '*.rdoc', '*.md'
  ]

  #s.add_runtime_dependency 'tzinfo'

  s.add_development_dependency 'rspec', '>= 2.13.0'

  s.require_path = 'lib'
end

