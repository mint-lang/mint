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
      # Initialize the workspace from the current working directory. We don't
      # check everything to speed things up so only the hot path is checked.
      workspace = Workspace.current
      workspace.check_everything = false
      workspace.check_env = true
      workspace.format = format?

      # Check if we have dependencies installed.
      workspace.json.check_dependencies!

      # On any change we update the result and notify all clients to
      # reload the application.
      workspace.on "change" do |result|
        @files =
          case result
          in Ast
            Bundler.new(
              artifacts: workspace.type_checker.artifacts,
              json: workspace.json,
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

        @sockets.each(&.send("reload"))
      end

      # Do the initial parsing and type checking and start wathing for changes.
      workspace.update_cache
      workspace.watch

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
