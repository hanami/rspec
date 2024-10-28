# frozen_string_literal: true

require_relative "lib/hanami/rspec/version"

Gem::Specification.new do |spec|
  spec.name          = "hanami-rspec"
  spec.version       = Hanami::RSpec::VERSION
  spec.authors       = ["Luca Guidi"]
  spec.email         = ["me@lucaguidi.com"]

  spec.summary       = "Hanami RSpec"
  spec.description   = "Hanami RSpec generators and Rake tasks"
  spec.homepage      = "https://hanamirb.org"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/hanami/rspec"
  spec.metadata["changelog_uri"] = "https://github.com/hanami/rspec/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "hanami-cli", "~> 2.2.rc"
  spec.add_dependency "rspec", "~> 3.12"
  spec.add_dependency "rake", "~> 13.0"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.add_development_dependency "rubocop", "~> 1.11"
  spec.metadata["rubygems_mfa_required"] = "true"
end
