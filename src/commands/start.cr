module Mint
  class Cli < Admiral::Command
    class Start < Admiral::Command
      include Command

      define_help description: "Starts the development server"

      define_flag auto_format : Bool,
        description: "Auto formats the source files when running development server",
        required: false,
        default: false

      define_flag host : String,
        description: "Change the host to serve the application on. (Default: 127.0.0.1)",
        default: ENV["HOST"]? || "127.0.0.1",
        required: false,
        short: "h"

      define_flag port : Int32,
        description: "Change the port to serve the application on. (Default: 3000)",
        default: (ENV["PORT"]? || "3000").to_i,
        required: false,
        short: "p"

      def run
        execute "Running the development server" do
          Reactor.start flags.host, flags.port, flags.auto_format
        end
      end
    end
  end
end
