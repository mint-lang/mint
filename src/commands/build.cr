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

      define_flag relative : Bool,
        description: "If specified, the URLs in the HTML will be in relative format.",
        default: false,
        short: "r"

      define_flag skip_icons : Bool,
        description: "If specified, the application icons will not be generated.",
        default: false

      define_flag generate_manifest : Bool,
        description: "If specified, the web manifest will be generated.",
        default: false

      define_flag verbose : Bool,
        description: "If specified, all written files will be logged.",
        default: false

      define_flag watch : Bool,
        description: "If specified, will build on every change.",
        default: false,
        short: "w"

      define_flag env : String,
        description: "Loads the given .env file.",
        short: "e"

      define_flag timings : Bool,
        description: "If specified, timings will be printed.",
        default: false

      def run
        execute "Building for production...", env: flags.env do
          # Initialize the workspace from the current working directory.
          # We don't check everything to speed things up so only the hot
          # path is checked.
          workspace = Workspace.current
          workspace.check_everything = false
          workspace.check_env = true

          # Check if we have dependencies installed.
          workspace.json.check_dependencies!

          # On any change we copy the build to the dist directory.
          workspace.on("change") do |result|
            terminal.reset if flags.watch

            case result
            in Ast
              terminal.puts "Building for production..."
              terminal.divider

              terminal.measure %(#{COG} Clearing the "#{DIST_DIR}" directory...") do
                FileUtils.rm_rf DIST_DIR
              end

              files =
                terminal.measure "#{COG} Building..." do
                  Bundler.new(
                    artifacts: workspace.type_checker.artifacts,
                    json: workspace.json,
                    config: Bundler::Config.new(
                      generate_manifest: flags.generate_manifest,
                      skip_icons: flags.skip_icons,
                      optimize: !flags.no_optimize,
                      runtime_path: flags.runtime,
                      relative: flags.relative,
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
                  ->{ File.write_p(Path[DIST_DIR, chopped], content) }

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
          end

          # Do the initial parsing and type checking.
          workspace.update_cache

          # Start wathing for changes if the flag is set.
          if flags.watch
            workspace.watch
            sleep
          end
        end
      end
    end
  end
end
