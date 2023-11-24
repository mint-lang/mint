module Mint
  class TestRunner
    include Errorable

    # The resulting files of bundling.
    @files : Hash(String, Proc(String)) = {} of String => Proc(String)

    # The socket of the current testing session.
    @socket : HTTP::WebSocket?

    # The reporter which processes the messages.
    @reporter : Reporter

    # Whether or not we are in watch mode.
    @watch : Bool

    delegate :failed?, to: @reporter

    def initialize(flags : Cli::Test::Flags, @arguments : Cli::Test::Arguments)
      @reporter = resolve_reporter(flags.reporter.downcase)
      @browser = Browser.new(flags.browser.downcase)
      @watch = flags.watch || flags.manual

      workspace = Workspace.current
      workspace.test_path = arguments.test || "*"
      workspace.check_env = true

      workspace.on "change" do |result|
        case result
        in Ast
          @files =
            Bundler.new(
              artifacts: workspace.type_checker.artifacts,
              json: MintJson.new,
              config: Bundler::Config.new(
                runtime_path: flags.runtime,
                generate_manifest: false,
                include_program: false,
                live_reload: false,
                hash_assets: true,
                skip_icons: true,
                optimize: false,
                relative: false,
                test: {
                  url: "ws://#{flags.browser_host}:#{flags.browser_port}/",
                  id:  "",
                })
            ).bundle

          unless flags.manual
            # Stop and cleanup previous browser session
            @browser.cleanup

            terminal.puts "#{COG} Starting browser..." unless @watch

            spawn do
              @browser.open("http://#{flags.browser_host}:#{flags.browser_port}")
            end
          end
        in Error
          terminal.puts(result.to_terminal)
        end
      end

      websocket_handler =
        HTTP::WebSocketHandler.new do |socket|
          # Stop previous socket if there is one.
          @socket.try(&.close)
          @socket = socket

          # Reset the reporter so the messages are not
          # compounded and such.
          @reporter.reset

          terminal.reset if @watch
          terminal.puts "#{COG} Running tests:"

          socket.on_message do |data|
            case data
            when "DONE"
              finish
            else
              message =
                Message
                  .from_json(data)
                  .tap(&->@reporter.process(Message))

              case message.type
              when "CRASHED"
                finish
              end
            end
          end
        end

      @server =
        HTTP::Server.new([
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

      Server.run(
        host: flags.host,
        port: flags.port,
        server: @server
      ) do |host, port|
        terminal.puts "#{COG} Test server started: http://#{host}:#{port}/"

        # Trigger first session
        workspace.update_cache

        if @watch
          terminal.puts "#{COG} Waiting for a browser to connect..."

          # Watch for changes...
          workspace.watch
        end
      end
    end

    private def resolve_reporter(reporter : String) : Reporter
      case reporter
      when "documentation"
        DocumentationReporter.new
      when "dot"
        DotReporter.new
      else
        error! :invalid_reporter do
          block do
            text "There is no reporter with the name:"
            bold reporter
          end

          snippet "The available reporters are:", "documentation, dot"
        end
      end
    end

    private def finish
      @reporter.report

      return if @watch

      @server.close
      @browser.stop
    end

    private def terminal
      Render::Terminal::STDOUT
    end
  end
end
