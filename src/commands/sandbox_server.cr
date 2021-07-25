module Mint
  class Cli < Admiral::Command
    class SandboxServer < Admiral::Command
      define_help description: "Server for compiling sandbox applications"

      define_flag host : String,
        description: "Change the host the server binds to. (Default: 0.0.0.0)",
        default: ENV["HOST"]? || "0.0.0.0",
        required: false,
        short: "h"

      define_flag port : Int32,
        description: "Change the port the server binds to. (Default: 3003)",
        default: (ENV["PORT"]? || "3003").to_i,
        required: false,
        short: "p"

      define_flag runtime : String,
        description: "Will use supplied runtime path instead of the default distribution",
        required: false

      def run
        server = Mint::SandboxServer.new(flags.host, flags.port, flags.runtime)
        server.start
      end
    end
  end
end
