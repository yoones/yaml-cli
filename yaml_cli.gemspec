# frozen_string_literal: true

require_relative "lib/yaml_cli/version"

Gem::Specification.new do |spec|
  spec.name = "yaml-cli"
  spec.version = YamlCli::VERSION
  spec.authors = ["Younes SERRAJ"]
  spec.email = ["younes.serraj@gmail.com"]

  spec.summary = "CLI to manipulate yaml files (cat, grep, mv, ...)"
  spec.description = "Set of binaries that facilitate yaml files manipulations such as searching for a key/value, extracting or moving a subset, etc."
  spec.homepage = "https://github.com/yoones/yaml-cli"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yoones/yaml-cli"
  spec.metadata["changelog_uri"] = "https://github.com/yoones/yaml-cli/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  # spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.executables = %w[yaml-cat yaml-grep]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
