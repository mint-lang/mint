module Mint
  class Cli < Admiral::Command
    class Docs < Admiral::Command
      include Command

      define_help description: "Starts the documentation server"

      register_sub_command generate, type: DocsGenerate

      def run
        execute "Running the documentation server" do
          DocumentationServer.start
        end
      end
    end
  end
end
