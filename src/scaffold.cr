module Mint
  class Scaffold
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

    getter name

    def self.run(name : String)
      new(name).run
    end

    def initialize(@name : String)
    end

    def run
      terminal.print "#{COG} Creating directory structure...\n"
      FileUtils.mkdir name
      FileUtils.cd name
      FileUtils.mkdir "source"

      terminal.print "#{COG} Writing initial files...\n\n"
      File.write(File.join("source", "Main.mint"), MAIN)
      File.write("mint.json", json.to_pretty_json)

      directory = Dir.current.colorize.mode(:bold)
      Installer.new
    end

    def json
      {
        "name"               => name,
        "source-directories" => [
          "source",
        ],
        "dependencies" => {
          "mint-core" => {
            "repository" => "https://github.com/mint-lang/mint-core",
            "constraint" => "0.0.0 <= v < 1.0.0",
          },
        },
      }
    end

    private def terminal
      Render::Terminal::STDOUT
    end
  end
end
