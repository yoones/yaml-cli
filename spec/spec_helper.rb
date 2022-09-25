# frozen_string_literal: true

require "yaml_cli"
require_relative "./support/exit_status_helpers"
require_relative "./support/fixture_file_helper"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.add_setting :fixture_files_path
  config.fixture_files_path = File.join(File.dirname(__FILE__), "fixtures")

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include FixtureFileHelper
end
