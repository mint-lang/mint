module Mint
  class MintJson
    def parse_root
      @parser.read_object do |key|
        case key
        when "source-directories"
          parse_source_directories
        when "test-directories"
          parse_test_directories
        when "dependencies"
          parse_dependencies
        when "mint-version"
          parse_mint_version
        when "application"
          parse_application
        when "formatter"
          parse_formatter
        when "name"
          parse_name
        else
          error! :root_invalid_key do
            snippet "The root object has an invalid key:", key
            snippet "It is here:", snippet_data
          end
        end
      end
    rescue JSON::ParseException
      error! :root_invalid do
        snippet "The root item should be an object, but it's not:", snippet_data
      end
    end
  end
end
