module Mint
  class Cli < Admiral::Command
    class Build < Admiral::Command
      include Command

      define_help description: "Builds the project for production"

      def run
        execute "Building for production" do
          Builder.new
        end
      end
    end
  end
end
