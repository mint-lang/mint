module Mint
  class Reactor
    # The resulting files.
    @files : Hash(String, Proc(String)) = {} of String => Proc(String)

    # The currently connected clients.
    @sockets = [] of HTTP::WebSocket

    def initialize(
      *,
      @reload : Bool,
      hash_routing,
      dot_env,
      format,
      host,
      port,
      &listener : Proc(TypeChecker, Hash(String, Proc(String)))
    )
      Workspace.new(
        path: Path[Dir.current, "mint.json"].to_s,
        dot_env: dot_env || ".env",
        check: Check::Environment,
        include_tests: false,
        format: format,
        listener: ->(result : Workspace::Result) do
          @files =
            case value = result.value
            in TypeChecker
              listener.call(value)
            in Error
              ErrorMessage.render(value, live_reload: @reload)
            end

          @sockets.each(&.send("reload")) if @reload
        end)

      # The websocket handle saves the sockets when they connect and
      # removes them when they disconnect.
      websocket_handler =
        HTTP::WebSocketHandler.new do |socket|
          @sockets.push socket.tap(&.on_close { @sockets.delete(socket) })
        end

      server =
        HTTP::Server.new([
          HTTP::CompressHandler.new,
          websocket_handler,
        ]) do |context|
          path = URI.decode(context.request.path)
          path = path.lchop("/") if hash_routing

          # Handle the request depending on the result.
          content_type, content =
            if file = @files[path]?
              {
                MIME.from_filename?(path).to_s || "text/plain",
                file.call,
              }
            else
              {"text/html", @files["/index.html"].call}
            end

          context.response.content_type = content_type
          context.response.print content
        end

      # Start the server.
      Server.run(
        server: server,
        host: host,
        port: port
      ) do |resolved_host, resolved_port|
        terminal.puts "#{COG} Development server started on http://#{resolved_host}:#{resolved_port}/"
      end
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
