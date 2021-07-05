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
      define_flag live_reload : Bool,
        description: "Whether or not to reload the browser when something changes. (Default true)",
        required: false,
        default: true,
        short: "r"

      define_flag source_map : Bool,
        description: "If specified generate source mappings for debugging",
        default: true,
        required: false,
        short: "m"

      def run
        execute "Running the development server" do
          Reactor.start flags.host, flags.port, flags.auto_format, flags.live_reload, flags.source_map
        end
      end
    end
  end
end
