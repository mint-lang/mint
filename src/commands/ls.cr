module Mint
  class Cli < Admiral::Command
    class Ls < Admiral::Command
      define_help description: "Language Server"

      def run
        Colorize.enabled = false

        server = LS::Server.new(STDIN, STDOUT)

        loop do
          server.read
        end
      end
    end
  end
end
