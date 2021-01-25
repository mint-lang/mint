module Mint
  # Reactor is the development server of Mint, it has the following features:
  # * Serve the compiled application script, index file, and favicons
  # * Watch all source files (application and packages as well) and if any
  #   changed it removes its AST from the cache, parses it
  #   again and then recompile the application script
  # * Renders any error as HTML
  # * Keeps a cache of ASTs of the parsed files for faster recompilation
  # * When --auto-format flag is passed all source files are watched and if
  #   any changes it formats the file
  class Reactor
    @sockets = [] of HTTP::WebSocket
    @error : String?
    @ast : Ast = Ast.new
    @script = ""
    @host : String
    @port : Int32
    @auto_format : Bool

    getter ast : Ast = Ast.new
    getter script = ""

    def self.start(host : String, port : Int32, auto_format : Bool)
      new host, port, auto_format
    end

    def initialize(@host, @port, @auto_format)
      terminal.measure "#{COG} Ensuring dependencies... " do
        MintJson.parse_current.check_dependencies!
      end

      workspace = Workspace.current
      workspace.format = auto_format

      init(workspace)

      workspace.on "change" do |result|
        update result
        notify
      end

      workspace.watch

      watch_for_changes
      setup_kemal

      Server.run "Development", @host, @port, @host, @port
    end

    def init(workspace)
      prefix = "#{COG} Parsing files"
      line = ""

      elapsed = Time.measure do
        workspace.initialize_cache do |_, index, size|
          counter =
            "#{index} / #{size}".colorize.mode(:bold)

          line =
            "#{prefix}: #{counter}".ljust(line.size)

          terminal.io.print(line + "\r")
          terminal.io.flush
        end
      end

      elapsed = TimeFormat.auto(elapsed).colorize.mode(:bold)
      terminal.io.puts "#{prefix}... #{elapsed}".ljust(line.size)

      @ast = workspace.ast
      compile_script
    rescue exception : Error
      @error = exception.to_html
    end

    def update(result)
      case result
      when Ast
        @ast = result
        @error = nil
        compile_script
      when Error
        @error = result.to_html
      end
    end

    def compile_script
      # Fetch options from the applications
      json =
        MintJson.parse_current

      # Create a brand new TypeChecker.
      type_checker =
        TypeChecker.new(ast)

      # Type check.
      type_checker.check

      # Compile.
      @script = Compiler.compile type_checker.artifacts, {
        optimize:   false,
        css_prefix: json.application.css_prefix,
      }
      @error = nil
    rescue exception : Error
      @error = exception.to_html
      @script = ""
    end

    def index
      if @error
        <<-HTML
        <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <script src="/live-reload.js"></script>
          </head>
          <body>
            #{@error}
          </body>
        </html>
        HTML
      else
        IndexHtml.render(Environment::DEVELOPMENT)
      end
    end

    # Sets up the kemal routes...
    def setup_kemal
      get "/index.js" do |env|
        env.response.content_type = "application/javascript"

        script
      end

      get "/external-javascripts.js" do |env|
        env.response.content_type = "application/javascript"

        SourceFiles.external_javascripts.to_s
      end

      get "/external-stylesheets.css" do |env|
        env.response.content_type = "text/css"

        SourceFiles.external_stylesheets.to_s
      end

      get "/:name" do |env|
        # Set cache to expire in 30 days.
        env.response.headers["Cache-Control"] = "max-age=2592000"

        # Try to figure out mime type from name in case it's baked or served
        # from public. Later on favicon and fallback content_type is overridden.
        env.response.content_type =
          MIME.from_filename?(env.params.url["name"]).to_s

        path = "./public/#{env.params.url["name"]}"

        # If there is any static file available serve that.
        if File.exists?(path)
          next File.read(path)
        end

        # If there is a baked file serve that.
        begin
          Assets.read(env.params.url["name"])
        rescue BakedFileSystem::NoSuchFileError
          match = env.params.url["name"].match(/icon-(\d+)x\d+\.png$/)

          # If it's a favicon generate it and return that.
          if match
            env.response.content_type =
              "image/png"

            json =
              MintJson.parse_current

            IconGenerator.convert(json.application.icon, match[1])
          else
            env.response.content_type =
              "text/html"

            # Else return the index so push state can work as intended.
            index
          end
        end
      end

      # If we didn't handle any route return the index as well.
      error 404 do |env|
        halt env, response: index, status_code: 200
      end

      # On websocket connections save the socket for notifications.
      ws "/" do |socket|
        @sockets.push socket

        socket.on_close do |_|
          @sockets.delete(socket)
        end
      end
    end

    # Notifies all connected sockets to reload the page.
    def notify
      @sockets.each do |socket|
        socket.send("reload")
      end
    end

    # Sets up watchers to detect changes
    def watch_for_changes
      Env.env.try do |file|
        spawn do
          Watcher.watch([file]) do
            Env.load do
              terminal.measure "#{COG} Environment variables changed recompiling... " do
                compile_script
              end

              notify
            end
          end
        end
      end
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
