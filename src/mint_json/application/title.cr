module Mint
  class MintJson
    def parse_application_title
      location =
        @parser.location

      title =
        @parser.read_string

      error! :application_title_empty do
        block do
          text "The"
          bold "title"
          text "field of the"
          bold "application object"
          text "should not be empty, but it is:"
        end

        snippet snippet_data(location)
      end if title.empty?

      title
    rescue JSON::ParseException
      error! :application_title_invalid do
        block do
          text "The"
          bold "title field"
          text "of the"
          bold "application object"
          text "should be a string, but it's not:"
        end

        snippet snippet_data
      end
    end
  end
end
