module Mint
  class Cli < Admiral::Command
    class Test < Admiral::Command
      include Command

      define_flag manual : Bool,
        description: "Start the test server for manual testing",
        long: "manual",
        default: false,
        short: "m"

      define_flag browser : String,
        description: "Which browser to run the tests in",
        default: "chromium",
        long: "browser",
        short: "b"

      define_flag reporter : String,
        description: "Which reporter to use (dot, documentation)",
        long: "reporter",
        default: "dot",
        short: "r"

      define_argument test : String

      define_help description: "Runs the tests."

      def run
        execute "Running Tests" do
          TestRunner.new(flags, arguments).run
        end
      end
    end
  end
end
