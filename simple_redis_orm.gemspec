# frozen_string_literal: true

require File.expand_path('../lib/simple_redis_orm/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors = ["Desmond O'Leary"]
  gem.email = ["desoleary@gmail.com"]
  gem.description = %q{Simple ORM backed with redis store}
  gem.summary = %q{Simple ORM backed with redis store}
  gem.homepage = "https://github.com/omnitech-solutions/simple-redis-orm"
  gem.license = "MIT"

  gem.files = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^exe/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec|features)/})
  gem.name = "simple_redis_orm"
  gem.require_paths = ["lib"]
  gem.version = SimpleRedisOrm::VERSION
  gem.required_ruby_version = ">= 2.6.0"

  gem.metadata["homepage_uri"] = gem.homepage
  gem.metadata["source_code_uri"] = gem.homepage
  gem.metadata["changelog_uri"] = "#{gem.homepage}/CHANGELOG.md"

  gem.add_development_dependency("rake", "~> 13.0.6")
  gem.add_development_dependency("rspec", "~> 3.12.0")
  gem.add_development_dependency("simplecov", "~> 0.21.2")
  gem.add_development_dependency("codecov", "~> 0.6.0")
end
