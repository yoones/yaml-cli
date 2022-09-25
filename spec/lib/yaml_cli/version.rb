# frozen_string_literal: true

require "spec_helper"

RSpec.describe YamlCli::Version do
  it "has a version number" do
    expect(YamlCli::VERSION).not_to be nil
  end
end
