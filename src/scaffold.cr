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

    GIT_IGNORE =
      <<-GIT_IGNORE
      .mint
      dist
      GIT_IGNORE

    getter path, name

    def self.run(name : String)
      path = File.expand_path(name)
      name = File.basename(path)
      new(path, name).run
    end

    def initialize(@path : String, @name : String)
    end

    def run
      terminal.print "#{COG} Creating directory structure...\n"
      FileUtils.mkdir_p path
      FileUtils.cd path
      FileUtils.mkdir "source"

      terminal.print "#{COG} Writing initial files...\n\n"
      File.write(File.join("source", "Main.mint"), MAIN)
      File.write("mint.json", json.to_pretty_json)
      File.write(".gitignore", GIT_IGNORE)

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
