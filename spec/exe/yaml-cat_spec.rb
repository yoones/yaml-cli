# frozen_string_literal: true

require "open3"

RSpec.describe "exe/yaml-cat" do
  let(:exe_path) do
    spec = Gem::Specification.find_by_name("yaml-cli")
    File.join(spec.gem_dir, "exe", "yaml-cat")
  end
  let(:fixtures_dir) do
    spec = Gem::Specification.find_by_name("yaml-cli")
    File.join(spec.gem_dir, "spec", "fixtures")
  end
  let(:args) { [] }
  let(:command) do
    ([exe_path] + args).join(" ")
  end

  it "is an executable file" do
    expect(File.executable?(exe_path)).to eq(true)
  end

  describe "with no argument" do
    include_examples "exits with failure status"

    it "outputs usage on stderr" do
      Open3.popen3(command) do |_stdin, _stdout, stderr, wait_thr|
        pid = wait_thr.pid
        exit_status = wait_thr.value
        expect(stderr.read).to include("Usage")
      end
    end
  end

  describe "--help" do
    let(:args) { ["--help"] }

    include_examples "exits with success status"

    it "outputs usage on stdout" do
      Open3.popen3(command) do |_stdin, stdout, _stderr, wait_thr|
        pid = wait_thr.pid
        exit_status = wait_thr.value
        expect(stdout.read).to include("Usage")
      end
    end
  end

  describe 'with required arguments given' do
    let(:args) { [filepath, fullkey] }
    let(:filepath) { fixture_file('en.yml').path }
    let(:fullkey) { 'en' }

    context 'when filepath does not exist' do
      let(:filepath) { 'inexistant_file.yml' }

      include_examples "exits with failure status"
      include_examples "does not output anything on stdout"
    end

    context 'when filepath exists' do
      context 'when no key given' do
        let(:args) { [filepath] }

        include_examples "exits with success status"

        it 'outputs the whole file' do
          Open3.popen3(command) do |_stdin, stdout, _stderr, wait_thr|
            pid = wait_thr.pid
            exit_status = wait_thr.value
            expect(stdout.read).to(
              eq(
                "---\nen:\n  user:\n    title: Basic user\n  admin:\n    title: Administrator\nfr:\n  user:\n    title: Utilisateur basique\n  admin:\n    title: Administrateur\n"
              )
            )
          end
        end
      end

      context 'when a single key is given' do
        context 'when the key is empty' do
          let(:fullkey) { '' }

          include_examples "exits with success status"

          it 'outputs the whole file' do
            Open3.popen3(command) do |_stdin, stdout, _stderr, wait_thr|
              pid = wait_thr.pid
              exit_status = wait_thr.value
              expect(stdout.read).to(
                eq(
                  "---\nen:\n  user:\n    title: Basic user\n  admin:\n    title: Administrator\nfr:\n  user:\n    title: Utilisateur basique\n  admin:\n    title: Administrateur\n"
                )
              )
            end
          end
        end

        context 'when the key does not exist' do
          let(:fullkey) { 'inexistant_key' }

          include_examples "exits with failure status"
          include_examples "does not output anything on stdout"
        end

        context "when the key exists" do
          let(:fullkey) { 'en.admin' }
          let(:expected_output) do
            <<~EOF
            ---
            en:
              admin:
                title: Administrator
            EOF
          end

          it 'outpus the requested subset' do
            Open3.popen3(command) do |_stdin, stdout, _stderr, wait_thr|
              pid = wait_thr.pid
              exit_status = wait_thr.value
              expect(stdout.read).to eq(expected_output)
            end
          end
        end
      end

      xcontext 'when multiple keys are given' do
        let(:args) { [filepath, fullkey_1, fullkey_2] }
        let(:fullkey_1) { 'en.admin' }
        let(:fullkey_2) { 'fr.user' }

        context 'when one of the keys does not exist' do
          let(:fullkey) { 'inexistant_key' }

          include_examples "exits with success status"

          it "outputs key structure only"
        end

        context "when the key exists" do
          let(:fullkey) { 'en.admin' }
          let(:expected_output) do
            <<~EOF
            ---
            en:
              admin:
                title: Administrator
            EOF
          end

          it 'outpus the requested subset' do
            Open3.popen3(command) do |_stdin, stdout, _stderr, wait_thr|
              pid = wait_thr.pid
              exit_status = wait_thr.value
              expect(stdout.read).to eq(expected_output)
            end
          end
        end
      end
    end
  end
end
