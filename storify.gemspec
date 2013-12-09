Gem::Specification.new do |s|
  s.name        = 'storify'
  s.version     = '0.0.1'
  s.date        = '2013-12-10'
  s.summary     = 'Storify API'
  s.description = 'Ruby Implementation of Storify API'
  s.authors     = ['Rizwan Tejpar']
  s.email       = 'rtejpar@gmail.com' 
  s.homepage    = 'http://rubygems.org/gems/storify'
  s.license     = 'MIT'  
  s.files       = Dir.glob('lib/**/*.rb')
  s.test_files  = Dir.glob('spec/*.rb')
  s.add_development_dependency 'rspec', '>=2.14.1'
end