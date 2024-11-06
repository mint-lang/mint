module Mint
  module LS
    # A server to use the LSP over websockets.
    class WebSocketServer < Server
      def initialize(@socket : HTTP::WebSocket, sandbox : Bool = false)
        # We need these for compability with the server, they are not used.
        @out = IO::Memory.new
        @in = IO::Memory.new

        @socket.on_message { |message| process(message) }
        @socket.on_close { cleanup }

        @sandbox = Sandbox.new(self) if sandbox
      end

      def cleanup
        @sandbox.try(&.cleanup)
      end

      def workspace(path : String) : Workspace
        @sandbox.try(&.workspace) || super(path)
      end

      def send(content : String)
        @socket.send(content) unless @socket.closed?
      end
    end
  end
end
