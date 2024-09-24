module Mint
  class MintJson
    class Parser
      def parse_application_name : String
        @parser.read_string
      rescue JSON::ParseException
        error! :application_name_invalid do
          block do
            text "The"
            bold "name field"
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
