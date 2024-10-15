module Mint
  module LS
    class Sandbox
      getter workspace : Workspace
      getter directory : Path

      def initialize(@server : Server)
        @json_raw = {"source-directories" => ["."]}.to_json
        @json = MintJson.parse(@json_raw, "mint.json")
        @id = Random::Secure.hex

        # We create a temporary directory for the workspace with a "mint.json"
        # so the `Workspace` can work.
        @directory =
          Path[Dir.tempdir, @id].tap do |directory|
            FileUtils.mkdir_p(directory)
            File.write(Path[directory, "mint.json"], @json_raw)
          end

        # There is only one workspace.
        @workspace =
          Workspace.new(
            path: Path[@directory, "mint.json"].to_s,
            listener: ->build(TypeChecker | Error),
            check: Check::Unreachable,
            include_tests: true,
            format: false)
      end

      def reset(files : Array(Tuple(String, String)))
        Dir.glob("#{@directory}/**/*") do |file|
          next if file == Path[@directory, "mint.json"].to_s
          FileUtils.rm(file)
        end

        files.each { |file| File.write_p(Path[@directory, file[0]], file[1]) }

        # We sleep to let the watcher pick up on changes.
        sleep 0.2.seconds
      end

      def update(file : Tuple(String, String))
        File.write_p(Path[@directory, file[0]].to_s, file[1])

        # We sleep to let the watcher pick up on changes.
        sleep 0.2.seconds
      end

      def build(result : TypeChecker | Error)
        @server.send_notification("sandbox/compiling", nil)

        bundle =
          case result
          in TypeChecker
            Bundler.new(
              artifacts: result.artifacts,
              config: Bundler::Config.new(
                generate_manifest: false,
                include_program: true,
                hash_assets: false,
                live_reload: false,
                runtime_path: nil,
                skip_icons: true,
                optimize: true,
                json: @json,
                test: nil),
            ).bundle
          in Error
            ErrorMessage.render(result)
          end

        IO::Memory.new.tap do |io|
          Compress::Zip::Writer.open(io) do |zip|
            bundle.each do |path, contents|
              zip.add(path, contents.call)
            end
          end

          io.rewind

          # TODO: Handle response.
          HTTP::Client.post("https://#{@id}.sandbox.mint-lang.com/", body: io)

          # Send notification so the client can refresh.
          @server.send_notification("sandbox/compiled", {
            url: "https://#{@id}.sandbox.mint-lang.com/",
          })
        end
      end

      def cleanup
        FileUtils.rm_rf(@directory)
      end
    end
  end
end
