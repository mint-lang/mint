module Mint
  class Cli < Admiral::Command
    class Start < Admiral::Command
      include Command

      define_help description: "Starts the development server."

      define_flag runtime : String,
        description: "If specified, the supplied runtime will be used instead of the default."

      define_flag no_reload : Bool,
        description: "Do not reload the browser when something changes.",
        default: false

      define_flag generate_source_maps : Bool,
        description: "If specified, source maps will be generated.",
        default: false

      define_flag hash_routing : Bool,
        description: "If specified, the hash routing will be used.",
        default: false

      define_flag format : Bool,
        description: "Formats the source files when they change.",
        default: false

      define_flag host : String,
        description: "The host to serve the application on.",
        default: ENV["HOST"]? || "0.0.0.0",
        short: "h"

      define_flag port : Int32,
        description: "The port to serve the application on.",
        default: (ENV["PORT"]? || "3000").to_i,
        short: "p"

      define_flag env : String,
        description: "Loads the given .env file.",
        short: "e"

      def run
        execute "Running the development server",
          check_dependencies: true do
          Reactor.new(
            hash_routing: flags.hash_routing,
            reload: !flags.no_reload,
            format: flags.format,
            dot_env: flags.env,
            host: flags.host,
            port: flags.port
          ) do |type_checker|
            Bundler.new(
              artifacts: type_checker.artifacts,
              config: Bundler::Config.new(
                generate_source_maps: flags.generate_source_maps,
                hash_routing: flags.hash_routing,
                live_reload: !flags.no_reload,
                runtime_path: flags.runtime,
                generate_manifest: false,
                json: MintJson.current,
                include_program: true,
                hash_assets: false,
                skip_icons: false,
                optimize: false,
                test: nil),
            ).bundle
          end
        end
      end
    end
  end
end
