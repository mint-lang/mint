module Mint
  class Cli < Admiral::Command
    class SandboxServer < Admiral::Command
      define_help description: "Server for compiling sandbox applications"

      define_flag host : String,
        description: "Change the host to serve the application on. (Default: 127.0.0.1)",
        default: ENV["HOST"]? || "127.0.0.1",
        required: false,
        short: "h"

      define_flag port : Int32,
        description: "Change the port to serve the application on. (Default: 3002)",
        default: (ENV["PORT"]? || "3002").to_i,
        required: false,
        short: "p"

      def run
        server = Mint::SandboxServer.new(flags.host, flags.port)
        server.start
      end
    end
  end
end
