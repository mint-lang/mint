module Mint
  class Cli < Admiral::Command
    class LsWebSocket < Admiral::Command
      include Command

      define_help description: "Starts the language server (websocket server)."

      define_flag sandbox : Bool,
        description: "If specified, server will start in sandbox mode.",
        default: false

      define_flag host : String,
        description: "The host to serve the language server on.",
        default: ENV["HOST"]? || "0.0.0.0",
        short: "h"

      define_flag port : Int32,
        description: "The port to serve the language server on.",
        default: (ENV["PORT"]? || "3003").to_i,
        short: "p"

      def run
        execute "Running language server over websocket" do
          server =
            HTTP::Server.new(
              [
                CORS.new,
                HTTP::WebSocketHandler.new do |socket|
                  LS::WebSocketServer.new(socket, flags.sandbox)
                end,
              ])

          Server.run(
            port: flags.port,
            host: flags.host,
            server: server,
          ) do |resolved_host, resolved_port|
            terminal.puts "#{COG} Language server started on http://#{resolved_host}:#{resolved_port}/"
          end
        end
      end
    end
  end
end
