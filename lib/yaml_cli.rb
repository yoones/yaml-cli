# frozen_string_literal: true

require "yaml"
require_relative "yaml_cli/version"
require_relative "yaml_cli/error"
require_relative "yaml_cli/extractable"
require_relative "yaml_cli/mutable"
require_relative "yaml_cli/searchable"

class YamlCli
  include Extractable
  include Mutable
  include Searchable

  attr_reader :hash

  def initialize(hash: nil)
    @hash = hash || {}
  end

  def load_file(filepath)
    @hash = YAML.load_file(filepath)
    self
  end

  def key_valid?(key, allow_blank: false)
    (allow_blank || key.length > 0) &&
      key[0] != '.' &&
      key[-1] != '.'
  end
end
