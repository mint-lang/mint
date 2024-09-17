module Mint
  class Cli < Admiral::Command
    class SandboxServer < Admiral::Command
      include Command

      define_help description: "Server for compiling sandbox applications."

      define_flag host : String,
        description: "The host the server binds to.",
        default: ENV["HOST"]? || "0.0.0.0",
        short: "h"

      define_flag port : Int32,
        description: "The port the server binds to.",
        default: (ENV["PORT"]? || "3003").to_i,
        short: "p"

      def run
        execute "Running the sandbox server" do
          # NOTE: The command and the server itself has the same name.
          Mint::SandboxServer.new(flags.host, flags.port)
        end
      end
    end
  end
end
