# frozen_string_literal: true

module ExitStatusHelpers
  shared_examples "exits with success status" do
    it "exits with success status code" do
      Open3.popen3(command) do |_stdin, _stdout, _stderr, wait_thr|
        pid = wait_thr.pid
        exit_status = wait_thr.value
        expect(exit_status.success?).to eq(true)
      end
    end
  end

  shared_examples "exits with failure status" do
    it "exits with failure status code" do
      Open3.popen3(command) do |_stdin, _stdout, _stderr, wait_thr|
        pid = wait_thr.pid
        exit_status = wait_thr.value
        expect(exit_status.success?).to eq(false)
      end
    end
  end

  shared_examples "does not output anything on stdout" do
    it "exits with success status code" do
      Open3.popen3(command) do |_stdin, stdout, _stderr, wait_thr|
        pid = wait_thr.pid
        exit_status = wait_thr.value
        expect(stdout.read).to eq("")
      end
    end
  end
end
