module Mint
  class Scaffold
    HEAD =
      <<-HEAD
      <!-- Put HTML tags here for loading JavaScript or CSS files. -->
      HEAD

    MAIN =
      <<-MAIN
      component Main {
        style base {
          font-family: sans;
          font-weight: bold;
          font-size: 50px;

          justify-content: center;
          align-items: center;
          display: flex;
          height: 100vh;
          width: 100vw;
        }

        fun render : Html {
          <div::base>
            <{ "Hello Mint!" }>
          </div>
        }
      }
      MAIN

    GIT_IGNORE =
      <<-GIT_IGNORE
      .mint
      dist
      GIT_IGNORE

    TEST =
      <<-TEST
      suite "Main" {
        test "Greets Mint" {
          with Test.Html {
            <Main/>
            |> start()
            |> assertTextOf("div", "Hello Mint!")
          }
        }
      }
    TEST

    getter path, name

    def self.run(name : String)
      path = File.expand_path(name)
      name = File.basename(path)
      new(path, name).run
    end

    def initialize(@path : String, @name : String)
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

      FileUtils.mkdir_p path
      FileUtils.cd path

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
