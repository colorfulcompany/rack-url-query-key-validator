# frozen_string_literal: true

require_relative "lib/rack/url_query_key_validator/version"

Gem::Specification.new do |spec|
  spec.name = "rack-url-query-key-validator"
  spec.version = Rack::UrlQueryKeyValidator::VERSION
  spec.authors = ["Colorful Company"]
  spec.email = ["webmaster@colorfulcompany.co.jp"]

  spec.summary = "A Rack middleware for validate URL Query Keys"
  spec.homepage = "https://github.com/colorfulcompany/rack-url-query-key-validator"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

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
  spec.add_runtime_dependency "rack"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.13.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
end
