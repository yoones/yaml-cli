# frozen_string_literal: true

require "spec_helper"
require "support/extractable_interface"

RSpec.describe YamlCli do
  let(:yaml_cli) { described_class.new }

  it "has a version number" do
    expect(YamlCli::VERSION).not_to be(nil)
  end

  include_examples "extractable interface"

  describe "#load_file" do
    subject { yaml_cli.load_file(fixture_file("minimal.yml").path) }

    it "loads the given yaml filepath into memory" do
      expect { subject }.to(
        change { yaml_cli.hash.to_json }
          .from("{}")
          .to('{"hello":"world"}')
      )
    end

    it "is a chainable method" do
      expect(subject).to be_a(described_class)
    end
  end
end
