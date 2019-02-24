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
      terminal.print "#{COG} Creating directory structure...\n"
      source_file_name = "source"
      tests_file_name = "tests"

      FileUtils.mkdir_p path
      FileUtils.cd path
      FileUtils.mkdir source_file_name if !File.exists? source_file_name
      FileUtils.mkdir tests_file_name if !File.exists? tests_file_name

      terminal.print "#{COG} Writing initial files...\n\n"
      File.write(File.join(source_file_name, "Main.mint"), MAIN)
      File.write(File.join(tests_file_name, "Main.mint"), TEST)
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
