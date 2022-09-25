# frozen_string_literal: true

require 'json'

module FixtureFileHelper
  class FixtureFile
    attr_reader :path

    def initialize(directory:, filename:)
      @directory = directory
      @filename = filename
      @path = File.absolute_path(File.join(directory, filename))
    end

    def read
      File.read(path)
    end

    private

    attr_reader :directory, :filename
  end

  def fixture_file(filename)
    FixtureFile.new(
      directory: RSpec.configuration.fixture_files_path,
      filename: filename
    )
  end
end
