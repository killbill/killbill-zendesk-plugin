version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.name        = 'killbill-zendesk'
  s.version     = version
  s.summary     = 'Plugin to mirror Kill Bill data into Zendesk'
  s.description = 'Kill Bill notification plugin for Zendesk.'

  s.required_ruby_version = '>= 1.9.3'

  s.license = 'Apache License (2.0)'

  s.author   = 'Kill Bill core team'
  s.email    = 'killbilling-users@googlegroups.com'
  s.homepage = 'http://killbill.io'

  s.files         = Dir['lib/**/*']
  s.bindir        = 'bin'
  s.require_paths = ["lib"]

  s.rdoc_options << '--exclude' << '.'

  s.add_dependency 'killbill', '~> 8.0'

  s.add_dependency 'sinatra', '~> 1.3.4'
  s.add_dependency 'zendesk_api', '~> 0.3.10'
  s.add_dependency 'mime-types', '< 3'
  s.add_dependency 'protected_attributes', '~> 1.1.3'
  s.add_dependency 'activerecord', '~> 4.1.0'
  if defined?(JRUBY_VERSION)
    s.add_dependency 'activerecord-bogacs', '~> 0.3'
    s.add_dependency 'activerecord-jdbc-adapter', '~> 1.3', '< 1.5'
    s.add_dependency 'jruby-openssl', '~> 0.9.7'
  end

  s.add_development_dependency 'jbundler', '~> 0.9.2'
  s.add_development_dependency 'rake', '>= 10.0.0'
  s.add_development_dependency 'rspec', '~> 2.12.0'
  if defined?(JRUBY_VERSION)
    s.add_development_dependency 'jdbc-sqlite3', '~> 3.7'
    s.add_development_dependency 'jdbc-mariadb', '~> 1.1'
  else
    s.add_development_dependency 'sqlite3', '~> 1.3.7'
  end
end
