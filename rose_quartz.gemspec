$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'rose_quartz/version'
Gem::Specification.new do |spec|
  spec.name          = 'rose_quartz'
  spec.version       = RoseQuartz::VERSION
  spec.authors       = ['little-bobby-tables']
  spec.email         = ['little-bobby-tables@users.noreply.github.com']

  spec.summary       = 'An extremely narrow in scope, convention-over-configuration TOTP integration for Rails'
  spec.homepage      = 'https://github.com/little-bobby-tables/rose_quartz'
  spec.license       = 'The Unlicense'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rails', '~> 5.0'
  spec.add_runtime_dependency 'devise', '~> 4.2'
  spec.add_runtime_dependency 'rotp', '~> 3.3'
  spec.add_runtime_dependency 'attr_encrypted', '~> 3.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'sqlite3'
end
