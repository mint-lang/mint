module Mint
  class Cli < Admiral::Command
    class SandboxServer < Admiral::Command
      define_help description: "Server for compiling sandbox applications"

      def run
        server = Mint::SandboxServer.new
        server.start
      end
    end
  end
end
