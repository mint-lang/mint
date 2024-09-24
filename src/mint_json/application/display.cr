module Mint
  class MintJson
    class Parser
      DISPLAY_VALUES =
        %w[fullscreen standalone minimal-ui browser]

      def parse_application_display : String
        @parser.location.try do |location|
          @parser.read_string.tap do |value|
            error! :application_display_mismatch do
              block do
                text "The"
                bold "value"
                text "of the"
                bold "display field"
                text "should be one of:"
              end

              snippet DISPLAY_VALUES.join("\n")
              snippet "It is here:", snippet_data(location)
            end unless DISPLAY_VALUES.includes?(value)
          end
        end
      rescue JSON::ParseException
        error! :application_display_invalid do
          block do
            text "The"
            bold "display field"
            text "of the"
            bold "application object"
            text "should be a string, but it's not:"
          end

          snippet snippet_data
        end
      end
    end
  end
end
