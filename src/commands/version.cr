module Mint
  class Cli < Admiral::Command
    class Version < Admiral::Command
      include Command

      define_help description: "Shows version."

      def run
        terminal.puts "Mint #{Mint::VERSION}"
      end
    end
  end
end
