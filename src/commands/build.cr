module Mint
  class Cli < Admiral::Command
    class Build < Admiral::Command
      include Command

      define_help description: "Builds the project for production"

      define_flag relative : Bool,
        description: "If specified the URLs in the index.html will be in relative format",
        default: false,
        short: "r"

      define_flag skip_service_worker : Bool,
        description: "If specified the service worker functionality will be disabled",
        default: false

      def run
        execute "Building for production" do
          Builder.new(flags.relative, flags.skip_service_worker)
        end
      end
    end
  end
end
