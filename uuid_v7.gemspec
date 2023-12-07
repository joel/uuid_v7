# frozen_string_literal: true

require_relative "lib/uuid_v7/version"

Gem::Specification.new do |spec|
  spec.name = "uuid_v7"
  spec.version = UuidV7::VERSION
  spec.authors = ["Joel Azemar"]
  spec.email = ["joel.azemar@gmail.com"]

  spec.summary = "Provides UUID V7 support for Ruby on Rails applications using Mysql and Sqlite."
  spec.description = "uuid_v7 enables UUID V7 as primary keys in Rails, optimized for Mysql and Sqlite, with efficient migration and integration features."

  spec.homepage = "https://github.com/alliantist/uuid_v7"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.1"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem

  spec.add_dependency "activemodel", "~> 7.0"
  spec.add_dependency "activesupport", "~> 7.0"
  spec.add_dependency "base58", "~> 0.2.3" # Used to convert between integers and base58 strings.
  spec.add_dependency "securerandom", "~> 0.3.0" # Needed for SecureRandom.uuid_v7 until we upgrade to Ruby 3.3
  spec.add_dependency "zeitwerk", "~> 2.5" # Used to autoload classes

  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
