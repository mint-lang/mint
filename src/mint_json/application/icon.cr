module Mint
  class MintJson
    def parse_application_icon
      location =
        @parser.location

      icon =
        @parser.read_string

      path =
        Path[@root, icon].to_s

      error! :application_icon_not_exists do
        block do
          text "The"
          bold "icon"
          text "field of"
          bold "the application object"
          text "points to a file that does not exists."
        end

        block do
          text "It should point to an image which will be used to generate"
          text "favicons for the application."
        end

        snippet snippet_data(location)
      end unless File.exists?(path)

      icon
    rescue JSON::ParseException
      error! :application_icon_invalid do
        block do
          text "The"
          bold "icon"
          text "field of"
          bold "the application object"
          text "should be a string, but it's not:"
        end

        snippet snippet_data
      end
    end
  end
end
