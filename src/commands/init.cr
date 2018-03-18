class Cli < Admiral::Command
  class Init < Admiral::Command
    include Command

    define_help description: "Initializes a new project"

    define_argument name,
      description: "The name of the new project",
      required: true

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

    def run
      execute "Initializing new project" do
        puts "#{Terminal.cog} Creating directory structure..."
        FileUtils.mkdir arguments.name
        FileUtils.cd arguments.name
        FileUtils.mkdir "source"

        puts "#{Terminal.cog} Writing initial files..."
        File.write(File.join("source", "Main.mint"), MAIN)
        File.write("mint.json", json.to_pretty_json)

        puts "\nInitialized new project in #{Dir.current.colorize.mode(:bold)}"
      end
    end

    def json
      {
        "name"               => arguments.name,
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
  end
end
