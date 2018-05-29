module Mint
  # Reactor is the development server of Mint, it have the following features:
  # * Servers the compiled application script, index file and favicons
  # * Watches all source files (application and packages as well) and if any
  #   changed it removes its AST from the cache, parses it
  #   again and then recompiles the application script
  # * Renders any error as HTML
  # * Keeps a cache of ASTs of the parsed files for faster recompilation
  # * When --auto-format flag is passed all source files are watched and if
  #   any changes it formats the file
  class Reactor
    def self.start(auto_format : Bool, port : Int32)
      new auto_format, port
    end

    getter script

    @sockets = [] of HTTP::WebSocket
    @cache = {} of String => Ast
    @pattern = [] of String
    @script = ""
    @auto_format : Bool
    @port : Int32

    @error : String | Nil

    def initialize(@auto_format, @port)
      @pattern = SourceFiles.all
      @error = nil

      terminal.measure "#{COG} Compiling... " do
        compile_script
      end

      watch_for_changes
      setup_kemal

      terminal.print "#{COG} Starting development server on port #{@port}\n"
      Server.run @port
    end

    def compile_script
      # Compile and format all files that are not in the cache.
      Dir.glob(@pattern).each do |file|
        @cache[file] ||= begin
          artifact =
            Parser.parse(file)

          if @auto_format
            formatted =
              Formatter.new(artifact).format

            if formatted != File.read(file)
              File.write(file, formatted)
            end
          end

          artifact
        end
      end

      # Create a brand new AST.
      ast =
        @cache
          .values
          .reduce(Ast.new) { |memo, item| memo.merge item }

      # Create a brand new TypeChecker.
      type_checker =
        TypeChecker.new(ast)

      # Type check.
      type_checker.check

      # Compile.
      @script = Compiler.compile type_checker.artifacts, {beautify: false}
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
      get "/index.js" do
        script
      end

      get "/:name" do |env|
        # Set cache to expire in 30 days.
        env.response.headers["Cache-Control"] = "max-age=2592000"

        # If there is any static file available serve that.
        #
        # TODO: Use right mime type if possible
        if File.exists?("./public/#{env.params.url["name"]}")
          File.read("./public/#{env.params.url["name"]}")
        else
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
              # Else return the index so push state can work as intended.
              index
            end
          end
        end
      end

      # If we didn't handle any route return the index as well.
      error 404 do |env|
        halt env, response: index, status_code: 200
      end

      # On websocket connections save the socket for notificaitons.
      ws "/" do |socket|
        @sockets.push socket

        socket.on_close do |_|
          @sockets.delete(socket)
        end
      end
    end

    # Notifies all connected scokets to reload the page.
    def notify
      @sockets.each do |socket|
        socket.send("reload")
      end
    end

    # Sets up watchers to detect changes
    def watch_for_changes
      # The pattern of the source files can change when deleting a file
      # so we need to have an instance available.
      source_watcher =
        Watcher.new(@pattern)

      spawn do
        # When the mint.json changes
        Watcher.watch(["mint.json"]) do
          # We need to update the patterns because:
          # 1. packages could have been added or removed
          # 2. source directories could have been added or removed
          @pattern =
            SourceFiles.all

          # Reset the cache, this will cause a full recompilation, in the
          # future this could be changed to only remove files from the cache
          # that have been changed.
          @cache =
            {} of String => Ast

          # Update the pattern on the watcher.
          source_watcher.pattern =
            @pattern

          # Compile the scripts
          terminal.measure "#{COG} Configuration changed, recompiling... " do
            compile_script
          end

          # Notify listeners.
          notify
        end
      end

      spawn do
        # When a source files change
        source_watcher.watch do |files|
          # Remove them from the cache.
          files.each { |file| @cache.delete(file) }

          # Compile the script.
          terminal.measure "#{COG} Files changed, recompiling... " do
            compile_script
          end

          # Notify listeners.
          notify
        end
      end
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
