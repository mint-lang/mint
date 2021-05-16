require "ecr"

module Mint
  class TestRunner
    class Message
      include JSON::Serializable

      property type : String
      property name : String
      property result : String
    end

    BROWSER_PATHS = {
      firefox: {
        "firefox",
        "/Applications/Firefox.app/Contents/MacOS/firefox-bin",
      },
      chrome: {
        "chromium-browser",
        "chromium",
        "google-chrome",
        "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
      },
    }

    error BrowserNotFound
    error InvalidBrowser
    error InvalidReporter

    @reporter : DocumentationReporter | DotReporter

    def initialize(@flags : Cli::Test::Flags, @arguments : Cli::Test::Arguments)
      @reporter = resolve_reporter
      @channel = Channel(Nil).new
      @failed = [] of Message
      @succeeded = 0
      @script = ""

      browser_path unless @flags.manual
    end

    def run
      terminal.measure "#{COG} Ensuring dependencies... " do
        MintJson.parse_current.check_dependencies!
      end

      ast = terminal.measure "#{COG} Compiling tests... " do
        compile_ast.tap { |a| compile_script(a) }
      end

      if ast.try(&.suites.empty?)
        terminal.puts "\nThere are no tests to run!"
        return
      end

      terminal.puts "#{COG} Starting test server..."
      setup_kemal

      terminal.puts "#{COG} Starting browser..."
      open_page

      Server.run "Test", @flags.host, @flags.port, @flags.browser_host, @flags.browser_port
    end

    def browser_path
      paths = BROWSER_PATHS[@flags.browser.downcase]?

      raise InvalidBrowser, {
        "browser" => @flags.browser,
      } unless paths

      path =
        paths.find { |item| Process.run("which", args: [item]).success? }

      raise BrowserNotFound, {
        "browser" => @flags.browser,
      } unless path

      path
    end

    def compile_ast
      file_argument =
        @arguments.test

      ast =
        Ast.new.merge(Core.ast)

      sources =
        if file_argument
          Dir.glob([file_argument] + SourceFiles.all)
        else
          Dir.glob(SourceFiles.tests + SourceFiles.all)
        end

      sources.uniq!.reduce(ast) do |memo, file|
        artifact = Parser.parse(file)

        formatted =
          Formatter.new(MintJson.parse_current.formatter_config).format(artifact)

        unless formatted == File.read(file)
          File.write(file, formatted)
        end

        memo.merge artifact
        memo
      end
    end

    def compile_script(ast)
      type_checker =
        TypeChecker.new(ast)

      type_checker.check

      @script = Compiler.compile_with_tests type_checker.artifacts
    end

    def resolve_reporter
      case @flags.reporter.downcase
      when "documentation"
        DocumentationReporter.new
      when "dot"
        DotReporter.new
      else
        raise InvalidReporter, {"reporter" => @flags.reporter.downcase}
      end
    end

    def open_process(profile_directory)
      path = browser_path
      url = "http://#{@flags.browser_host}:#{@flags.browser_port}"

      case @flags.browser.downcase
      when "firefox"
        Process.new(
          path,
          args: [
            "--headless",
            "--width",
            "1920",
            "--height",
            "1080",
            "--profile",
            profile_directory,
            url,
          ]
        )
      when "chrome"
        Process.new(
          path,
          args: [
            "--headless",
            "--disable-gpu",
            "--remote-debugging-port=9222",
            "--profile-directory=#{profile_directory}",
            "--window-size=1920,1080",
            url,
          ]
        )
      else
        raise InvalidBrowser, {"browser" => @flags.browser}
      end
    end

    def open_browser
      return if @flags.manual

      profile_directory = Path[Dir.tempdir, Random.new.hex(5)].to_s
      Dir.mkdir(profile_directory)

      begin
        process = open_process(profile_directory)
        at_exit do
          process.signal(:kill) rescue nil
          FileUtils.rm_rf(profile_directory)
        end
        @channel.receive
      ensure
        process.try &.signal(:kill)
        FileUtils.rm_rf(profile_directory)
      end
    end

    def open_page
      spawn { open_browser }
    end

    def setup_kemal
      # ameba:disable Lint/UselessAssign
      ws_url =
        "ws://#{@flags.browser_host}:#{@flags.browser_port}/"

      page_source =
        ECR.render("#{__DIR__}/test_runner.ecr")

      get "/" do
        @failed = [] of Message
        @succeeded = 0
        page_source
      end

      get "/external-javascripts.js" do |env|
        env.response.content_type = "application/javascript"

        SourceFiles.external_javascripts.to_s
      end

      get "/external-stylesheets.css" do |env|
        env.response.content_type = "text/css"

        SourceFiles.external_stylesheets.to_s
      end

      get "/runtime.js" do
        Assets.read("runtime.js").to_s
      end

      get "/tests" do
        @script
      end

      ws "/" do |socket|
        terminal.puts "#{COG} Running tests:"

        socket.on_message do |message|
          case message
          when "DONE"
            @reporter.done
            sum = @succeeded + @failed.size

            terminal.divider
            terminal.puts "#{sum} tests"
            terminal.puts "  #{ARROW} #{@succeeded} passed"
            terminal.puts "  #{ARROW} #{@failed.size} failed"

            @failed.each do |failure|
              terminal.puts "    #{failure.name}".colorize(:red)
              terminal.puts "    |> #{failure.result}".colorize(:red)
            end

            stop_server
          else
            data = Message.from_json(message)
            case data.type
            when "LOG"
              terminal.puts data.result
            when "SUITE"
              @reporter.suite data.name
            when "SUCCEEDED"
              @reporter.succeeded data.name
              @succeeded += 1
            when "FAILED"
              @reporter.failed data.name, data.result
              @failed << data
            when "ERRORED"
              terminal.puts "An error occurred when running the test #{data.name}: #{data.result}".colorize(:red)
              @failed << data
            when "CRASHED"
              @reporter.crashed data.result

              stop_server
            end
          end
        end
      end
    end

    def stop_server
      Kemal.config.server.try(&.close) unless @flags.manual
      @channel.send(nil)
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
