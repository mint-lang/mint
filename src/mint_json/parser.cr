module Mint
  class MintJson
    class Parser
      include Errorable
      extend Errorable

      def self.parse(*, contents : String, path : String) : MintJson
        new(contents: contents, path: path).parse
      rescue exception : JSON::ParseException
        error! :invalid_json do
          block do
            text "I could not parse the following"
            bold "mint.json"
            text "file:"
          end

          snippet snippet_data(
            column_number: exception.location[1],
            line_number: exception.location[0],
            contents: contents,
            path: path)
        end
      end

      def self.parse(path : String, *, search : Bool = false) : MintJson
        file = path

        if search
          error! :mint_json_not_found do
            block do
              text "I could not find a"
              bold "mint.json"
              text "file in the path or any of its parent directories:"
            end

            snippet path
          end unless file = File.find_in_ancestors(path, "mint.json")
        end

        parse(contents: File.read(file), path: file)
      rescue error : Error
        raise error # Propagate our own errors.
      rescue exception
        error! :mint_json_invalid do
          block do
            text "There was a problem trying to open a"
            bold "mint.json"
            text "file:"
            bold path
          end

          snippet exception.to_s
        end
      end

      def initialize(*, @contents : String, @path : String)
        @parser = JSON::PullParser.new(@contents)
      end

      def self.snippet_data(
        *,
        column_number : Int32,
        line_number : Int32,
        contents : String,
        path : String,
      )
        position =
          if line_number - 1 == 0
            0
          else
            contents
              .lines[0..line_number - 2]
              .reduce(0) { |acc, line| acc + line.size + 1 }
          end + (column_number - 1)

        Error::SnippetData.new(
          to: position + 1,
          input: contents,
          filename: path,
          from: position)
      end

      def snippet_data(location : Tuple(Int32, Int32))
        self.class.snippet_data(
          column_number: location[1],
          line_number: location[0],
          contents: @contents,
          path: @path)
      end

      def snippet_data
        snippet_data @parser.location
      end

      # This is used for checking directories and files.
      def root
        File.dirname(@path)
      end
    end
  end
end
