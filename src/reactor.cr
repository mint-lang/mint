module Mint
  class Reactor
    # Whether or not to reload the browser after a change is made.
    getter? reload : Bool

    # Whether or not to format the files after a change is made.
    getter? format : Bool

    # The host to start the server on.
    getter host : String

    # The port to start the server on.
    getter port : Int32

    # The resulting files of bundling.
    @files : Hash(String, Proc(String)) = {} of String => Proc(String)

    # The currently connected clients.
    @sockets = [] of HTTP::WebSocket

    def initialize(*, @host, @port, @format, @reload)
      FileWorkspace.new(
        path: Path[Dir.current, "mint.json"].to_s,
        check: Check::Environment,
        include_tests: false,
        format: format?,
        watch: true
      ) do |result|
        @files =
          case result
          in TypeChecker
            Bundler.new(
              artifacts: result.artifacts,
              json: MintJson.current,
              config: Bundler::Config.new(
                generate_manifest: false,
                include_program: true,
                hash_assets: false,
                runtime_path: nil,
                live_reload: true,
                skip_icons: false,
                optimize: false,
                relative: false,
                test: nil),
            ).bundle
          in Error
            error(result)
          end

        @sockets.each(&.send("reload")) if reload?
      end

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
          # Handle the request depending on the result.
          content_type, content =
            if file = @files[context.request.path]?
              {
                MIME.from_filename?(context.request.path).to_s || "text/plain",
                file.call,
              }
            else
              {"text/html", @files["index.html"].call}
            end

          context.response.content_type = content_type
          context.response.print content
        end

      # Start the server.
      Server.run(
        server: server,
        host: host,
        port: port
      ) do |host, port|
        terminal.puts "#{COG} Development server started on http://#{host}:#{port}/"
      end
    end

    def error(error)
      {
        "/live-reload.js" => ->{ Assets.read("live-reload.js") },
        "index.html"      => ->{ error.to_html(reload?) },
      }
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
