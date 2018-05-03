module Mint
  class Cli < Admiral::Command
    class Start < Admiral::Command
      include Command

      define_help description: "Starts the development server."

      def run
        execute "Running the development server" do
          Reactor.start
        end
      end
    end
  end
end
