# frozen_string_literal: true

# dependencies: extractable (#get)

class YamlCli
  module Mutable
    def set(fullkey, hash)
      mkdir_p(fullkey)
      parent = get_parent(fullkey)
      key = basename(fullkey)
      parent[key] = hash
      self
    end

    def cp(source, dest, no_alias: false)
      subset = get(source)
      subset = Marshal.load(Marshal.dump(subset)) if no_alias
      set(dest, subset)
      self
    end

    def mv(source, dest)
      cp(source, dest)
      rm(source)
      self
    end

    def rm(fullkey)
      parent = get_parent(fullkey)
      key = basename(fullkey)
      parent.delete(key)
      self
    end

    def mkdir_p(fullkey)
      existing_key = get(fullkey)
      raise InvalidDestinationError unless existing_key.nil? || existing_key.is_a?(Hash)

      walker = hash
      path = fullkey.split(".")
      path.each do |step|
        walker[step] = {} unless walker.key?(step)
        walker = walker[step]
      end
    end

    private

    # def deep_sort
    #   @hash = hash.keys.sort.each_with_object({}) do |key, new_hash|
    #     value = hash[key]
    #     new_hash[key] = if value.is_a?(Hash)
    #                       deep_sort_hash(value)
    #                     else
    #                       value
    #                     end
    #   end
    # end

    def get_parent(fullkey)
      path = fullkey.split(".")
      if path.count == 1
        hash
      else
        path.pop
        hash.dig(*path)
      end
    end

    def basename(key)
      key.split(".").last
    end
  end
end
