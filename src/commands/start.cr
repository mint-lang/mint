module Mint
  class Cli < Admiral::Command
    class Start < Admiral::Command
      include Command

      define_help description: "Starts the development server."

      define_flag format : Bool,
        description: "Formats the source files when they change.",
        default: false

      define_flag reload : Bool,
        description: "Reload the browser when something changes.",
        default: true,
        short: "r"

      define_flag host : String,
        description: "The host to serve the application on.",
        default: ENV["HOST"]? || "0.0.0.0",
        short: "h"

      define_flag port : Int32,
        description: "The port to serve the application on.",
        default: (ENV["PORT"]? || "3000").to_i,
        short: "p"

      define_flag env : String,
        description: "Loads the given .env file.",
        short: "e"

      def run
        execute "Running the development server", env: flags.env do
          Reactor.new(
            format: flags.format,
            reload: flags.reload,
            host: flags.host,
            port: flags.port)
        end
      end
    end
  end
end
