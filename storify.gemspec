Gem::Specification.new do |s|
  s.name        = 'storify'
  s.version     = '0.0.1'
  s.date        = '2013-12-10'
  s.summary     = 'Storify API'
  s.description = 'Ruby Implementation of Storify API'
  s.authors     = ['Rizwan Tejpar']
  s.email       = 'rtejpar@gmail.com'
  s.files       = ['lib/storify.rb']
  s.homepage    = 'http://rubygems.org/gems/storify'
  s.license     = 'MIT'

  s.add_development_dependency 'rspec', '>=2.14.1'
  s.test_files = Dir.glob('spec/*.rb')
end