module Mint
  class Cli < Admiral::Command
    class Test < Admiral::Command
      include Command

      define_help description: "Runs the tests"

      define_flag manual : Bool,
        description: "Start the test server for manual testing",
        default: false,
        short: "m"

      define_flag browser : String,
        description: "Which browser to run the tests in (chrome, firefox)",
        default: "chrome",
        short: "b"

      define_flag reporter : String,
        description: "Which reporter to use (dot, documentation)",
        default: "dot",
        short: "r"

      define_flag host : String,
        description: "Host to serve the tests on. (Default: 127.0.0.1)",
        default: ENV["HOST"]? || "127.0.0.1",
        required: false,
        short: "h"

      define_flag port : Int32,
        description: "Port to serve the tests on. (Default: 3001)",
        default: (ENV["PORT"]? || "3001").to_i,
        required: false,
        short: "p"

      define_flag browser_host : String,
        description: "Target host, useful when hosted on another machine. (Default: 127.0.0.1)",
        default: ENV["BROWSER_HOST"]? || "127.0.0.1",
        required: false,
        short: "x"

      define_flag browser_port : Int32,
        description: "Target port, useful when hosted on another machine. (Default: 3001)",
        default: (ENV["BROWSER_PORT"]? || "3001").to_i,
        required: false,
        short: "c"

      define_flag runtime : String,
        description: "Will use supplied runtime path instead of the default distribution",
        required: false

      define_flag watch : Bool,
        description: "Watch files for changes and rerun tests",
        required: false

      define_argument test : String,
        description: "The path to the test file to run"

      def run
        MintJson.parse_current.check_dependencies!

        runner =
          TestRunner.new(flags, arguments)

        if flags.watch
          runner.watch
        else
          succeeded = nil

          execute "Running Tests" do
            succeeded = runner.run
          end

          exit(1) unless succeeded
        end
      end
    end
  end
end
