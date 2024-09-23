module Mint
  class MintJson
    def parse_mint_version
      location =
        @parser.location

      raw =
        @parser.read_string

      match =
        raw.match(/(\d+\.\d+\.\d+)\s*<=\s*v\s*<\s*(\d+\.\d+\.\d+)/)

      constraint =
        if match
          lower =
            Installer::Semver.parse?(match[1])

          upper =
            Installer::Semver.parse?(match[2])

          Installer::SimpleConstraint.new(lower, upper) if upper && lower
        end

      error! :mint_version_bad do
        block do
          text "The"
          bold "mint-version"
          text "constraint should be in this format:"
        end

        snippet "0.0.0 <= v < 1.0.0"
        snippet "It is here:", snippet_data(location)
      end unless constraint

      resolved =
        Installer::Semver.parse(VERSION.rchop("-devel"))

      error! :mint_version_mismatch do
        block do
          text "The"
          bold "mint-version"
          text "field does not match this version of Mint."
        end

        snippet "I was looking for", constraint.to_s
        snippet "but found instead:", VERSION

        snippet "It is here:", snippet_data(location)
      end unless resolved < constraint.upper && resolved >= constraint.lower
    rescue JSON::ParseException
      error! :mint_version_invalid do
        block do
          text "The"
          bold "mint-version"
          text "field should be a string, but it's not:"
        end

        snippet snippet_data
      end
    end
  end
end
