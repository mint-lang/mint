module Mint
  class MintJson
    class Application
      getter meta : Hash(String, String)
      getter orientation : String
      getter theme_color : String
      getter css_prefix : String
      getter display : String
      getter title : String
      getter icon : String
      getter head : String
      getter name : String

      def initialize(
        *,
        @orientation,
        @theme_color,
        @css_prefix,
        @display,
        @title,
        @meta,
        @name,
        @head,
        @icon
      )
      end
    end

    getter dependencies : Array(Installer::Dependency)
    getter source_directories : Array(String)
    getter test_directories : Array(String)
    getter formatter : Formatter::Config
    getter application : Application
    getter name : String
    getter path : String

    def initialize(
      *,
      @source_directories,
      @test_directories,
      @dependencies,
      @application,
      @formatter,
      @name,
      @path
    )
    end

    def self.parse(path : String, *, search : Bool = false) : MintJson
      Parser.parse(path, search: search)
    end

    def self.parse(contents : String, path : String) : MintJson
      Parser.parse(contents: contents, path: path)
    end

    def self.current : MintJson
      parse(Path[Dir.current, "mint.json"].to_s)
    end

    def self.current? : MintJson?
      current
    rescue
      nil
    end
  end
end
