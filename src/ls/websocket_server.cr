module Mint
  module LS
    # A server to use the LSP over websockets.
    class WebSocketServer < Server
      getter directory : Path

      def initialize(@socket : HTTP::WebSocket)
        @id = Random::Secure.hex

        # We need these for compability with the server.
        @out = IO::Memory.new
        @in = IO::Memory.new

        # The directory for the workspace.
        # TODO: Remove this when we have an in memory only workspace...
        @directory =
          Path[Dir.tempdir, @id].tap do |path|
            FileUtils.mkdir_p(path)

            File.write(Path[path, "mint.json"], {
              "source-directories" => ["."],
            }.to_json)
          end

        # The workspace to use.
        @workspace = Workspace.new(@directory.to_s)
        @workspace.presist_on_update = true

        @socket.on_message { |message| process(message) }
        @socket.on_close { FileUtils.rm_rf(directory) }
      end

      def workspace(path : String)
        @workspace
      end

      def workspace(uri : URI)
        @workspace
      end

      def send(content : String)
        @socket.send(content)
      end
    end
  end
end
