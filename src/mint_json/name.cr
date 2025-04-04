module Mint
  class MintJson
    class Parser
      def parse_name : String
        location =
          @parser.location

        name =
          @parser.read_string

        error! :name_empty do
          block do
            text "The"
            bold "name"
            text "field should not be empty:"
          end

          snippet snippet_data(location)
        end if name.empty?

        name
      rescue JSON::ParseException
        error! :name_invalid do
          block do
            text "The"
            bold "name"
            text "field should be a string, but it's not:"
          end

          snippet snippet_data
        end
      end
    end
  end
end
