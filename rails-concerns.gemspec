# coding: utf-8
lib = File.expand_path "../lib", __FILE__
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rails/concerns/version"

Gem::Specification.new do |spec|
  spec.name          = "rails-concerns"
  spec.version       = Rails::Concerns::VERSION
  spec.authors       = ["Jerod Santo"]
  spec.email         = ["jerod@objectlateral.com"]
  spec.description   = %q{Common Rails concerns used at OL}
  spec.summary       = %q{Common Rails concerns used at OL}
  spec.homepage      = "https://github.com/objectlateral/rails-concerns"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bcrypt", "~> 3.1.10"
  spec.add_dependency "hashids", "~> 1.0.2"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec", "~> 2.14.0"
  spec.add_development_dependency "activerecord", ">= 3.2.13"
  spec.add_development_dependency "sqlite3", ">= 1.3"
end
