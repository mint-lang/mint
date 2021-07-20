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

      define_flag skip_icons : Bool,
        description: "If specified the application icons will not be generated",
        default: false

      define_flag minify : Bool,
        description: "If specified the resulting JavaScript code will be minified",
        default: true,
        short: "m"

      define_flag runtime : String,
        description: "Will use supplied runtime path instead of the default distribution",
        required: false

      def run
        execute "Building for production" do
          Builder.new(
            flags.relative,
            flags.skip_service_worker,
            flags.skip_icons,
            flags.minify,
            flags.runtime
          )
        end
      end
    end
  end
end
