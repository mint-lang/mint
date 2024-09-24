module Mint
  class MintJson
    class Parser
      def parse_application_css_prefix : String
        @parser.read_string
      rescue JSON::ParseException
        error! :application_css_prefix_invalid do
          block do
            text "The"
            bold "css-prefix field"
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
