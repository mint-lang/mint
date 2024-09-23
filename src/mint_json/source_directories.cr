module Mint
  class MintJson
    def parse_source_directories
      @parser.location.try do |location|
        @parser.read_array(&->parse_source_directory)

        error! :source_directories_empty do
          block do
            text "The"
            bold "source-directories"
            text "field lists all directories (relative to the mint.json file)"
            text "which contain the source files of the application."
          end

          block do
            text "The"
            bold "source-directories"
            text "array should not be empty, but it is:"
          end

          snippet snippet_data(location)
        end if source_directories.empty?
      end
    rescue JSON::ParseException
      error! :source_directories_invalid do
        block do
          text "The"
          bold "source-directories"
          text "field lists all directories (relative to the mint.json file)"
          text "which contain the source files of the application."
        end

        block do
          text "The"
          bold "source-directories"
          text "field should be an array, but it's not:"
        end

        snippet snippet_data
      end
    end

    def parse_source_directory
      location =
        @parser.location

      directory =
        @parser.read_string

      path =
        Path[@root, directory]

      error! :source_directory_not_exists do
        block do
          text "The source directory"
          bold directory
          text "does not exists:"
        end

        snippet snippet_data(location)
      end unless Dir.exists?(path)

      source_directories << directory
    rescue JSON::ParseException
      error! :source_directory_invalid do
        block do
          text "All entries in the"
          bold "source-directories"
          text "array should be string:"
        end

        snippet snippet_data
      end
    end
  end
end
