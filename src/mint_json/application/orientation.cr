module Mint
  class MintJson
    ORIENTATION_VALUES =
      %w[
        any natural landscape landscape-primary
        landscape-secondary portrait portrait-primary
        portrait-secondary
      ]

    def parse_application_orientation
      @parser.location.try do |location|
        @parser.read_string.tap do |value|
          error! :application_orientation_mismatch do
            block do
              text "The"
              bold "value"
              text "of the"
              bold "orientation field"
              text "should be one of:"
            end

            snippet ORIENTATION_VALUES.join("\n")
            snippet "It is here:", snippet_data(location)
          end unless ORIENTATION_VALUES.includes?(value)
        end
      end
    rescue JSON::ParseException
      error! :application_orientation_invalid do
        block do
          text "The"
          bold "orientation field"
          text "of the"
          bold "application object"
          text "should be a string, but it's not:"
        end

        snippet snippet_data
      end
    end
  end
end
