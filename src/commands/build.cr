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

      define_flag noServiceWorker : Bool,
        description: "If specified the service worker functionality will be disabled",
        long: "noServiceWorker",
        default: false,
        short: "s"

      def run
        execute "Building for production" do
          Builder.new(flags.relative, flags.noServiceWorker)
        end
      end
    end
  end
end
