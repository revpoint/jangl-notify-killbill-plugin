version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.name        = 'killbill-jangl-notify'
  s.version     = version
  s.summary     = 'Plugin to send notifications to Jangl'
  s.description = 'Killbill plugin for taking actions in Jangl.'

  s.required_ruby_version = '>= 1.9.3'

  s.license = 'Apache License (2.0)'

  s.author   = 'Jangl Tech'
  s.email    = 'tech@jangl.com'
  s.homepage = 'https://jan.gl'

  s.files         = Dir['lib/**/*']
  s.bindir        = 'bin'
  s.require_paths = ['lib']

  s.rdoc_options << '--exclude' << '.'

  s.add_dependency 'killbill', '~> 9.0'

  s.add_development_dependency 'jbundler', '~> 0.9.2'
  s.add_development_dependency 'rake', '>= 10.0.0', '< 11.0.0'
  s.add_development_dependency 'rspec', '~> 2.12.0'
end
