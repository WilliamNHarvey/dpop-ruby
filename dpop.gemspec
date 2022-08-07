# frozen_string_literal: true

require_relative "lib/dpop/version"

Gem::Specification.new do |spec|
  spec.name = "dpop"
  spec.version = Dpop::VERSION
  spec.authors = ["WilliamNHarvey"]
  spec.email = ["williamnharvey@gmail.com"]

  spec.summary = "Implementation of DPoP (Demonstrating Proof-of-Possession at the Application Layer) for Ruby and Rails apps"
  spec.homepage = "https://github.com/WilliamNHarvey/dpop-ruby"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/WilliamNHarvey/dpop-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/WilliamNHarvey/dpop-ruby/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_dependency "activesupport"
  spec.add_dependency "jwt"
  spec.add_dependency "openssl"
end
