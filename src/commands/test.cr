module Mint
  class Cli < Admiral::Command
    class Test < Admiral::Command
      include Command

      define_help description: "Runs the tests defined for the project."

      define_flag runtime : String,
        description: "If specified, the supplied runtime will be used instead of the default."

      define_flag browser : String,
        description: "Which browser to run the tests in (chrome, firefox).",
        default: "chrome",
        short: "b"

      define_flag browser_host : String,
        description: "Target host, useful when hosted on another machine.",
        default: ENV["BROWSER_HOST"]? || "127.0.0.1",
        short: "x"

      define_flag browser_port : Int32,
        description: "Target port, useful when hosted on another machine.",
        default: (ENV["BROWSER_PORT"]? || "3001").to_i,
        short: "c"

      define_flag reporter : String,
        description: "Which reporter to use (dot, documentation),",
        default: "dot",
        short: "r"

      define_flag manual : Bool,
        description: "Start the test server for manual testing.",
        default: false,
        short: "m"

      define_flag watch : Bool,
        description: "Watch files for changes and rerun tests."

      define_flag host : String,
        description: "Host to serve the tests on.",
        default: ENV["HOST"]? || "127.0.0.1",
        short: "h"

      define_flag port : Int32,
        description: "Port to serve the tests on.",
        default: (ENV["PORT"]? || "3001").to_i,
        short: "p"

      define_flag env : String,
        description: "Loads the given .env file.",
        short: "e"

      define_argument test : String,
        description: "The path to the test file to run."

      def run
        runner =
          execute "Running Tests", env: flags.env do
            TestRunner.new(flags, arguments)
          end

        exit(1) if runner.try(&.failed?)
      end
    end
  end
end
