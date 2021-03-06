Gem::Specification.new do |s|
  s.name        = 'storify'
  s.version     = '0.0.15'
  s.date        = '2013-12-26'
  s.summary     = 'Storify API'
  s.description = 'Ruby Wrapper of Storify REST API -- work-in-progress'
  s.authors     = ['Rizwan Tejpar']
  s.email       = 'rtejpar@gmail.com'
  s.homepage    = 'https://github.com/natural-affinity/storify'
  s.license     = 'MIT'
  s.files       = Dir.glob('lib/**/*.rb')
  s.test_files  = Dir.glob('spec/**/*.rb')
  s.test_files += Dir.glob('fixtures/**/*.yml')

  s.add_runtime_dependency 'json', '>=1.7.7'
  s.add_runtime_dependency 'rest-client', '>=1.6.7'
  s.add_runtime_dependency 'representable', '>=1.7.3'
  s.add_runtime_dependency 'nokogiri', '>=1.6.0'
  s.add_development_dependency 'rspec', '>=2.14.1'
  s.add_development_dependency 'webmock', '>=1.16.1'
  s.add_development_dependency 'vcr', '~>2.8'
end
