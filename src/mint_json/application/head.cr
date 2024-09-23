module Mint
  class MintJson
    def parse_application_head
      location =
        @parser.location

      head =
        @parser.read_string

      path =
        Path[@root, head].to_s

      error! :application_head_not_exists do
        block do
          text "The"
          bold "head"
          text "field of"
          bold "the application object"
          text "points to a file that does not exists."
        end

        block do
          text "It should point to an HTML file, which be injected to the"
          text "<head> tag of the generated HTML. It is used to include"
          text "external dependencies (CSS, JS, analytics, etc...)"
        end

        snippet snippet_data(location)
      end unless File.exists?(path)

      File.read(path)
    rescue JSON::ParseException
      error! :application_head_invalid do
        block do
          text "The"
          bold "head"
          text "field of"
          bold "the application object"
          text "should be a string, but it's not:"
        end

        snippet snippet_data
      end
    end
  end
end
