module Mint
  class Cli < Admiral::Command
    class Clean < Admiral::Command
      include Command

      define_help description: "Removes artifacts (directories) created by Mint."

      define_flag package_cache : Bool,
        description: "If specified, cleans the package cache directory.",
        default: false

      def run
        execute "Removing directories" do
          ArtifactCleaner.clean flags.package_cache
        end
      end
    end
  end
end
