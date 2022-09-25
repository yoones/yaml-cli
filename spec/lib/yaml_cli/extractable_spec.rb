# frozen_string_literal: true

require "spec_helper"
require "support/extractable_interface"

RSpec.describe YamlCli::Extractable do
  subject { yaml_cli }

  let(:yaml_cli) do
    YamlCli.new.load_file(fixture_file("en.yml").path)
  end

  include_examples "extractable interface"

  describe "#get" do
    subject { yaml_cli.get(requested_key) }

    context "when blank key requested" do
      let(:requested_key) { "" }

      it "returns the full hash" do
        expect(subject).to be_a(Hash)
        expect(subject.to_s).to(
          eq(
            '{"en"=>{"user"=>{"title"=>"Basic user"}, "admin"=>{"title"=>"Administrator"}}, "fr"=>{"user"=>{"title"=>"Utilisateur basique"}, "admin"=>{"title"=>"Administrateur"}}}'
          )
        )
      end
    end

    context "when invalid key requested" do
      shared_examples "raises error" do
        it "raises error" do
          expect { subject }.to raise_error(YamlCli::Error)
        end
      end

      context "when key starts with a dot" do
        let(:requested_key) { ".en" }

        include_examples "raises error"
      end

      context "when key ends with a dot" do
        let(:requested_key) { "en." }

        include_examples "raises error"
      end
    end

    context "when inexistant key requested" do
      subject { yaml_cli.get("inexistant_key") }

      it "returns nil" do
        expect(subject).to eq(nil)
      end
    end

    context "when a root key is requested" do
      subject { yaml_cli.get("en") }

      it "returns the value of the requested key" do
        expect(subject).to be_a(Hash)
        expect(subject.to_s).to(
          eq(
            '{"user"=>{"title"=>"Basic user"}, "admin"=>{"title"=>"Administrator"}}'
          )
        )
      end
    end

    context "when a subkey is requested" do
      subject { yaml_cli.get("en.admin") }

      it "returns the value of the requested key" do
        expect(subject).to be_a(Hash)
        expect(subject.to_s).to(
          eq(
            '{"title"=>"Administrator"}'
          )
        )
      end
    end
  end

  describe "#exists?" do
    subject { yaml_cli.exists?(requested_key) }

    context "when blank key requested" do
      let(:requested_key) { "" }

      it "returns true" do
        expect(subject).to eq(true)
      end
    end

    context "when invalid key requested" do
      shared_examples "raises error" do
        it "raises error" do
          expect { subject }.to raise_error(YamlCli::Error)
        end
      end

      context "when key starts with a dot" do
        let(:requested_key) { ".en" }

        include_examples "raises error"
      end

      context "when key ends with a dot" do
        let(:requested_key) { "en." }

        include_examples "raises error"
      end
    end

    context "when key does not exist" do
      let(:requested_key) { "inexistant_key" }

      it "returns false" do
        expect(subject).to eq(false)
      end
    end

    context "when key exists" do
      let(:requested_key) { "en.admin" }

      it "returns true" do
        expect(subject).to eq(true)
      end
    end
  end

  describe "#cat" do
    let(:requested_key) { 'en.admin' }

    shared_examples "returns a yaml-valid string" do
      it "returns a yaml-valid string" do
        expect { YAML.load(subject) }.not_to raise_error
        expect(YAML.load(subject)).to be_a(Hash)
      end
    end

    shared_examples "returns expected value with preserved path" do
      include_examples "returns a yaml-valid string"

      it "returns the expected value under the requested key path" do
        expect(subject).to(
          eq(
            "---\nen:\n  admin:\n    title: Administrator\n"
          )
        )
      end
    end

    shared_examples "returns expected value without preserved path" do
      include_examples "returns a yaml-valid string"

      it "returns the requested value at the root level" do
        expect(subject).to(
          eq(
            "---\ntitle: Administrator\n"
          )
        )
      end
    end

    context "when :preserve_path not explicitely set" do
      subject { yaml_cli.cat(requested_key) }

      include_examples "returns expected value with preserved path"
    end

    context "with preserve_path: true" do
      subject { yaml_cli.cat(requested_key, preserve_path: true) }

      include_examples "returns expected value with preserved path"
    end

    context "with preserve_path: false" do
      subject { yaml_cli.cat(requested_key, preserve_path: false) }

      include_examples "returns expected value without preserved path"
    end
  end
end
