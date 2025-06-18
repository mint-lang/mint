module Mint
  class Cli < Admiral::Command
    class Build < Admiral::Command
      include Command

      define_help description: "Builds the project for production."

      define_flag runtime : String,
        description: "If specified, the supplied runtime will be used instead of the default."

      define_flag no_optimize : Bool,
        description: "If specified, the resulting JavaScript code will not be optimized.",
        default: false

      define_flag skip_icons : Bool,
        description: "If specified, the application icons will not be generated.",
        default: false

      define_flag generate_manifest : Bool,
        description: "If specified, the web manifest will be generated.",
        default: false

      define_flag generate_source_maps : Bool,
        description: "If specified, source maps will be generated.",
        default: false

      define_flag verbose : Bool,
        description: "If specified, all written files will be logged.",
        default: false

      define_flag hash_routing : Bool,
        description: "If specified, the hash routing will be used.",
        default: false

      define_flag watch : Bool,
        description: "If specified, will build on every change.",
        default: false,
        short: "w"

      define_flag timings : Bool,
        description: "If specified, timings will be printed.",
        default: false

      define_flag env : String,
        description: "Loads the given .env file.",
        short: "e"

      def run
        execute "Building for production",
          check_dependencies: true do
          Workspace.new(
            path: Path[Dir.current, "mint.json"].to_s,
            dot_env: flags.env || ".env",
            check: Check::Environment,
            include_tests: false,
            format: false,
            listener: ->(result : TypeChecker | Error) do
              terminal.reset if flags.watch

              case result
              in TypeChecker
                terminal.measure %(#{COG} Clearing the "#{DIST_DIR}" directory...) do
                  FileUtils.rm_rf DIST_DIR
                end

                files =
                  terminal.measure "#{COG} Building..." do
                    Bundler.new(
                      artifacts: result.artifacts,
                      config: Bundler::Config.new(
                        generate_source_maps: flags.generate_source_maps,
                        generate_manifest: flags.generate_manifest,
                        hash_routing: flags.hash_routing,
                        skip_icons: flags.skip_icons,
                        optimize: !flags.no_optimize,
                        runtime_path: flags.runtime,
                        json: MintJson.current,
                        include_program: true,
                        live_reload: false,
                        hash_assets: true,
                        test: nil)).bundle
                  end || {} of String => Proc(String)

                bundle_size = 0

                files.keys.sort_by!(&.size).reverse!.each do |path|
                  chopped =
                    path.lchop('/')

                  content =
                    files[path].call

                  size =
                    content.bytesize

                  proc =
                    -> { File.write_p(Path[DIST_DIR, chopped], content) }

                  bundle_size +=
                    size

                  if flags.verbose
                    terminal.measure "#{COG} Writing #{chopped} (#{size.humanize_bytes(format: :JEDEC)})..." do
                      proc.call
                    end
                  else
                    proc.call
                  end
                end

                terminal.divider
                terminal.puts "Bundle size: #{bundle_size.humanize_bytes(format: :JEDEC)}"
                terminal.puts "Files: #{files.size}"

                if flags.timings
                  terminal.divider
                  Logger.print(terminal)
                end
              in Error
                terminal.print result.to_terminal
              end
            end)

          # Start wathing for changes if the flag is set.
          sleep if flags.watch
        end
      end
    end
  end
end
