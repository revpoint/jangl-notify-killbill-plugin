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

  s.files = Dir.glob(%w(
    lib/**/*
    spec/**/*
    *.gemspec
    *.md
    Gemfile
    LICENSE
    vendor/jar-dependencies/**/*.jar
    vendor/jar-dependencies/**/*.rb
    VERSION
  ))

  s.bindir        = 'bin'
  s.require_paths = ['lib']

  s.rdoc_options << '--exclude' << '.'

  s.add_dependency 'killbill', '~> 9.0'

  s.add_dependency "avro"  #(Apache 2.0 license)
  s.add_dependency "schema_registry", ">= 0.1.0" #(MIT license)

  s.add_development_dependency 'jbundler', '~> 0.9.2'
  s.add_development_dependency 'rake', '>= 10.0.0', '< 11.0.0'
  s.add_development_dependency 'rspec', '~> 2.12.0'

  s.add_development_dependency 'jar-dependencies', '~> 0.4.1'
  s.add_development_dependency 'ruby-maven', '~> 3.3', '>= 3.3.8'

end
