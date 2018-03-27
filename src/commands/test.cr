require "kemal"

class Cli < Admiral::Command
  class Test < Admiral::Command
    include Mint::Logger
    include Command

    define_flag keep_alive : Bool,
      description: "Wether or not keep alive the testing server after",
      long: "keep-alive",
      default: false,
      short: "k"

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
      execute "Running tests in #{flags.browser}" do
        Mint::Test.new(flags, arguments).run
      end
    end
  end
end
