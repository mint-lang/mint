module Mint
  class Cli < Admiral::Command
    class Install < Admiral::Command
      include Command

      define_help description: "Installs dependencies."

      def run
        execute "Installing dependencies." do
          Installer.new
        end
      end
    end
  end
end
