module Mint
  class Cli < Admiral::Command
    class Clean < Admiral::Command
      include Command

      define_help description: "Removes artifacts (directories) created by Mint"

      define_flag global : Bool,
        description: "If specified, cleans global artifacts used to cache Mint packages",
        default: false,
        short: "g"

      def run
        execute "Removing directories" do
          ArtifactCleaner.clean flags.global
        end
      end
    end
  end
end
