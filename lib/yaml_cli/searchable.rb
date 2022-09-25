# frozen_string_literal: true

class YamlCli
  module Searchable
    def grep(keys, invert_match: false, exhaustive: false)
      find_matching_keys(
        hash,
        keys,
        invert_match: invert_match,
        exhaustive: exhaustive
      )
    end

    private

    def find_matching_keys(subhash, words, invert_match:, exhaustive:, parent_path: [])
      subhash.keys.each_with_object([]) do |key, matches|
        path = parent_path + [key]
        fullkey = path.join(".")
        match_found = if invert_match
                        words.none? { |word| fullkey.include?(word) }
                      else
                        words.all? { |word| fullkey.include?(word) }
                      end
        matches << fullkey if match_found
        next unless subhash[key].is_a?(Hash) && (!match_found || exhaustive)

        matches.append(
          find_matching_keys(
            subhash[key],
            words,
            parent_path: path,
            invert_match: invert_match,
            exhaustive: exhaustive
          )
        )
      end
    end
  end
end
