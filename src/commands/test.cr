module Mint
  class Cli < Admiral::Command
    class Test < Admiral::Command
      include Command

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

      define_argument test : String

      define_help description: "Runs the tests"

      def run
        execute "Running Tests" do
          TestRunner.new(flags, arguments).run
        end
      end
    end
  end
end
