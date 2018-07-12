module Mint
  class Cli < Admiral::Command
    class Build < Admiral::Command
      include Command

      define_help description: "Builds the project for production"

      define_flag relative : Bool,
        description: "If specified the URLs in the index.html will be in relative format",
        long: "relative",
        default: false,
        short: "r"

      def run
        execute "Building for production" do
          Builder.new(flags.relative)
        end
      end
    end
  end
end
