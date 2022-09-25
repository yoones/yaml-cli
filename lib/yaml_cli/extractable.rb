# frozen_string_literal: true

# dependencies: mutable (mkdir_p, set)

class YamlCli
  module Extractable
    def get(fullkey = "")
      raise YamlCli::Error unless key_valid?(fullkey, allow_blank: true)

      if fullkey == ""
        hash
      else
        hash.dig(*fullkey.split("."))
      end
    end

    def exists?(fullkey)
      raise YamlCli::Error unless key_valid?(fullkey, allow_blank: true)

      iterator = hash
      fullkey.split(".").each do |key|
        return false unless iterator.is_a?(Hash) && iterator.key?(key)

        iterator = iterator[key]
      end
      true
    end

    def cat(fullkey, preserve_path: true)
      raise YamlCli::Error unless key_valid?(fullkey, allow_blank: true)

      subset = if fullkey == ""
                 hash
               elsif preserve_path
                 temp = self.class.new
                 temp.mkdir_p(fullkey)
                 temp.set(fullkey, get(fullkey))
                 temp.hash
               else
                 get(fullkey)
               end
      subset.to_yaml
    end
  end
end
