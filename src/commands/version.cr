require "yaml"

module Mint
  class Cli < Admiral::Command
    class Version < Admiral::Command
      include Command

      define_help description: "Shows version"

      macro read_file_at_compile_time(filename)
        # Will work until Crystal supports Windows
        {{ `cat #{filename}`.stringify }}
      end

      def run
        execute "Showing version" do
          shard_file = read_file_at_compile_time("shard.yml")
          version = YAML.parse(shard_file)["version"]
          puts "Mint #{version}"
        end
      end
    end
  end
end
