module Mint
  class MintJson
    include Errorable

    class Application
      getter title, meta, icon, head, name, theme_color, display, orientation
      getter css_prefix

      def initialize(
        @meta = {} of String => String,
        @css_prefix : String? = nil,
        @orientation = "",
        @theme_color = "",
        @display = "",
        @title = "",
        @name = "",
        @head = "",
        @icon = ""
      )
      end
    end

    getter dependencies = [] of Installer::Dependency
    getter formatter_config = Formatter::Config.new
    getter parser = JSON::PullParser.new("{}")
    getter application = Application.new
    getter source_directories = %w[]
    getter test_directories = %w[]
    getter name = ""

    getter root : String
    getter file : String
    getter json : String

    def initialize(@json : String, @root : String, @file : String)
      begin
        @parser = JSON::PullParser.new(@json)
      rescue exception : JSON::ParseException
        error! :invalid_json do
          block do
            text "I could not parse the following"
            bold "mint.json"
            text "file:"
          end

          snippet snippet_data(exception)
        end
      end

      parse_root
    end

    def initialize
      @json = ""
      @root = ""
      @file = ""
    end

    def self.from_file(path)
      new File.read(path), File.dirname(path), path
    rescue error : Error
      raise error
    rescue error
      Errorable.error :mint_json_invalid do
        block do
          text "There was a problem trying to open a"
          bold "mint.json"
          text "file:"
          bold path
        end

        snippet error.to_s
      end
    end

    def self.parse_current : MintJson
      from_file(Path[Dir.current, "mint.json"].to_s)
    end

    def self.parse_current? : MintJson?
      parse_current
    rescue
      nil
    end

    def snippet_data(line_number : Int32, column_number : Int32)
      position =
        if line_number - 1 == 0
          0
        else
          @json
            .lines[0..line_number - 2]
            .reduce(0) { |acc, line| acc + line.size + 1 }
        end + (column_number - 1)

      Error::SnippetData.new(
        filename: @file,
        input: @json,
        to: position + 1,
        from: position)
    end

    def snippet_data(exception : JSON::ParseException)
      snippet_data exception.location
    end

    def snippet_data(location : Tuple(Int32, Int32))
      snippet_data location[0], location[1]
    end

    def snippet_data
      snippet_data @parser.location
    end

    def source_files
      glob =
        source_directories.map { |dir| SourceFiles.glob_pattern(@root, dir) }

      Dir.glob(glob)
    end
  end
end
