module Mint
  class Scaffold
    HEAD = {{read_file("#{__DIR__}/app/assets/head.html")}}
    MAIN = {{read_file("#{__DIR__}/app/source/Main.mint")}}
    TEST = {{read_file("#{__DIR__}/app/tests/Main.mint")}}
    GIT_IGNORE = {{read_file("#{__DIR__}/app/source/Main.mint")}}

    getter path : Path

    def self.run(name : Path | String)
      new(Path[name]).run
    end

    def initialize(path : Path)
      @path = path.expand
    end

    def name
      path.basename
    end

    def run
      files = {
        File.join("assets", "head.html") => HEAD,
        File.join("source", "Main.mint") => MAIN,
        File.join("tests", "Main.mint")  => TEST,
        "mint.json"                      => json.to_pretty_json,
        ".gitignore"                     => GIT_IGNORE,
      }

      directory =
        name
          .colorize(:light_green)
          .mode(:bold)

      terminal.puts "#{COG} Creating directory: #{directory}"

      FileUtils.mkdir_p path.to_s
      FileUtils.cd path.to_s

      terminal.puts "#{COG} Writing initial files:"

      files.each do |path, contents|
        FileUtils.mkdir_p File.dirname(path)
        terminal.puts "  #{ARROW} #{path}"

        File.write(path, contents)
      end
    end

    def json
      {
        "name"        => name,
        "application" => {
          "head"  => "assets/head.html",
          "title" => name,
        },
        "source-directories" => [
          "source",
        ],
        "test-directories" => [
          "tests",
        ],
      }
    end

    private def terminal
      Render::Terminal::STDOUT
    end
  end
end
