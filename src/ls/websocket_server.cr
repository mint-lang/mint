module Mint
  module LS
    # A server to use the LSP over websockets.
    class WebSocketServer < Server
      class Sandbox
        getter workspace : FileWorkspace

        @directory : Path

        def initialize(@server : Server)
          json = {"source-directories" => ["."]}.to_json
          @json = MintJson.parse(json, "mint.json")
          @id = Random::Secure.hex

          # We create a temporary directory for the workspace with a "mint.json"
          # so the `FileWorkspace` can work.
          @directory =
            Path[Dir.tempdir, @id].tap do |path|
              FileUtils.mkdir_p(path)
              File.write(Path[path, "mint.json"], json)
            end

          # There is only one workspace.
          @workspace =
            FileWorkspace.new(
              path: Path[@directory, "mint.json"].to_s,
              listener: ->build(TypeChecker | Error),
              check: Check::Unreachable,
              include_tests: true,
              format: false)
        end

        def build(result : TypeChecker | Error)
          bundle =
            case result
            in TypeChecker
              Bundler.new(
                artifacts: result.artifacts,
                json: @json,
                config: Bundler::Config.new(
                  generate_manifest: false,
                  include_program: true,
                  hash_assets: false,
                  live_reload: false,
                  runtime_path: nil,
                  skip_icons: true,
                  relative: false,
                  optimize: true,
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

      def initialize(@socket : HTTP::WebSocket, sandbox : Bool = false)
        # We need these for compability with the server, they are not used.
        @out = IO::Memory.new
        @in = IO::Memory.new

        @sandbox = Sandbox.new(self) if sandbox

        @socket.on_message { |message| process(message) }
        @socket.on_close { cleanup }
      end

      def cleanup
        @sandbox.try(&.cleanup)
      end

      def workspace(path : String) : FileWorkspace
        @sandbox.try(&.workspace) || super(path)
      end

      def send(content : String)
        @socket.send(content)
      end
    end
  end
end
