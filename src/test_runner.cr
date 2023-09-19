module Mint
  class TestRunner
    include Errorable

    class Message
      include JSON::Serializable

      property id : String
      property type : String
      property name : String?
      property suite : String?
      property result : String?

      property location : Ast::Node::Location?
    end

    BROWSER_PATHS = {
      firefox: {
        "firefox",
        "firefox-bin",
        "/Applications/Firefox.app/Contents/MacOS/firefox-bin",
      },
      chrome: {
        "chromium-browser",
        "chromium",
        "google-chrome",
        "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
      },
    }

    @artifacts : TypeChecker::Artifacts?
    @reporter : Reporter
    @browser_path : String?
    @browser : {Process, String}? = nil

    @failed = [] of Message
    @test_id = Random::Secure.hex
    @succeeded = 0

    def initialize(@flags : Cli::Test::Flags, @arguments : Cli::Test::Arguments)
      @reporter = resolve_reporter
      @browser_path = resolve_browser_path unless @flags.manual
      @channel = Channel(Nil).new
    end

    def reset
      @failed = [] of Message
      @succeeded = 0
    end

    def watch
      workspace = Workspace.current
      workspace.on "change" { run_tests }
      workspace.watch

      setup_kemal
      run_tests

      Server.run "Test", @flags.host, @flags.port, false
    end

    def run_tests
      @test_id = Random::Secure.hex
      cleanup_browser
      terminal.reset

      begin
        type_checker = TypeChecker.new(ast)
        type_checker.check

        @reporter.reset
        open_page
      rescue error : Error
        terminal.reset
        terminal.puts error.to_terminal
      rescue error
        terminal.reset
        terminal.puts error.to_s
      end
    end

    def run : Bool
      if ast.try(&.suites.empty?)
        terminal.puts
        terminal.puts "There are no tests to run!"
        return false
      end

      terminal.puts "#{COG} Starting test server..."
      setup_kemal

      unless @flags.manual
        terminal.puts "#{COG} Starting browser..."
        open_page
      end

      Server.run "Test", @flags.host, @flags.port

      @failed.empty?
    end

    def ast
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
        artifact =
          Parser.parse(file)

        memo.merge artifact
      end
    end

    def script
      type_checker = TypeChecker.new(ast)
      type_checker.check

      @artifacts = type_checker.artifacts

      Compiler.compile_with_tests(type_checker.artifacts)
    end

    def resolve_reporter : Reporter
      case @flags.reporter.downcase
      when "documentation"
        DocumentationReporter.new
      when "dot"
        DotReporter.new
      else
        error! :invalid_reporter do
          block do
            text "There is no reporter with the name:"
            bold @flags.reporter
          end

          snippet "The available reporters are:", "documentation, dot"
        end
      end
    end

    def resolve_browser_path : String
      paths =
        BROWSER_PATHS[@flags.browser.downcase] || [] of String

      path = paths
        .compact_map { |item| Process.find_executable(item) }
        .first?

      error! :browser_not_found do
        block do
          text "I cannot find the executable of browser:"
          bold @flags.browser
        end

        block do
          text "Are you sure it's installed properly?"
        end
      end unless path

      path
    end

    def open_process(path, profile_directory)
      url = "http://#{@flags.browser_host}:#{@flags.browser_port}"

      case @flags.browser.downcase
      when "firefox"
        Process.new(path, args: [
          "--headless",
          "--remote-debugging-port", "9222",
          "--window-size", "1920,1080",
          "--profile", profile_directory,
          url,
        ])
      when "chrome"
        Process.new(path, args: [
          "--headless",
          "--disable-gpu",
          "--remote-debugging-port=9222",
          "--window-size=1920,1080",
          "--profile-directory=#{profile_directory}",
          url,
        ])
      else
        error! :invalid_browser do
          block do
            text "I cannot run the tests in the given browser:"
            bold @flags.browser
          end

          snippet "The available browsers are:", "chrome, firefox"
        end
      end
    end

    def open_browser
      return unless browser_path = @browser_path

      profile_directory = Path[Dir.tempdir, Random.new.hex(5)].to_s
      Dir.mkdir(profile_directory)

      begin
        process = open_process(browser_path, profile_directory)
        @browser = {process, profile_directory}
        at_exit { cleanup_browser }
        @channel.receive
      ensure
        cleanup_browser
      end
    end

    def cleanup_browser
      @browser.try do |(process, profile_directory)|
        process.signal(:kill) rescue nil
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

      runtime =
        if runtime_path = @flags.runtime
          Cli.runtime_file_not_found(runtime_path) unless File.exists?(runtime_path)
          ::File.read(runtime_path)
        else
          Assets.read("runtime.js")
        end

      get "/" do
        reset
        ECR.render("#{__DIR__}/test_runner.ecr")
      end

      get "/external-javascripts.js" do |env|
        env.response.content_type = "application/javascript"

        SourceFiles.external_javascripts
      end

      get "/external-stylesheets.css" do |env|
        env.response.content_type = "text/css"

        SourceFiles.external_stylesheets
      end

      get "/#{ASSET_DIR}/:name" do |env|
        filename =
          env.params.url["name"]

        asset =
          @artifacts.try(&.assets.find(&.filename(build: false).==(filename)))

        next unless asset

        # Set cache to expire in 30 days.
        env.response.headers["Cache-Control"] = "max-age=2592000"

        # Try to figure out mime type from name.
        env.response.content_type =
          MIME.from_filename?(filename).to_s

        asset.file_contents
      end

      get "/runtime.js" do
        runtime
      end

      get "/tests" do
        script
      end

      ws "/" do |socket|
        terminal.puts "#{COG} Running tests:"

        socket.on_message do |message|
          case message
          when "DONE"
            shutdown
          else
            data = Message.from_json(message)
            handle_message(data)
          end
        end
      end
    end

    def handle_message(data : Message) : Nil
      if data.id == @test_id
        case data.type
        when "LOG"
          terminal.puts data.result
        when "SUITE"
          @reporter.suite data.suite
        when "SUCCEEDED"
          @reporter.succeeded data.name
          @succeeded += 1
        when "FAILED"
          @reporter.failed data.name, data.result
          @failed << data
        when "ERRORED"
          @reporter.errored data.name, data.result
          @failed << data
        when "CRASHED"
          @reporter.crashed data.result
          @failed << data

          @reporter.done
          stop_server unless @flags.watch
        end
      end
    end

    def shutdown
      @reporter.done
      sum = @succeeded + @failed.size

      terminal.divider
      terminal.puts "#{sum} tests"
      terminal.puts "  #{ARROW} #{@succeeded} passed"
      terminal.puts "  #{ARROW} #{@failed.size} failed"

      @failed
        .group_by(&.suite.to_s)
        .to_a
        .sort_by!(&.first)
        .each do |suite, failures|
          terminal.puts (suite.presence || "N/A")
            .indent(4)
            .colorize(:red)

          failures.each do |failure|
            terminal.puts "- #{failure.name}"
              .indent(6)
              .colorize(:red)

            terminal.puts "|> #{failure.result.presence || "N/A"}"
              .indent(8)
              .colorize(:red)

            if location = failure.location
              terminal.puts "<| #{location.filename}:#{location.start[0]}"
                .indent(8)
                .colorize(:dark_gray)
            end
          end
        end

      stop_server unless @flags.watch
    end

    def stop_server
      return if @flags.manual

      Kemal.config.server.try(&.close)
      @channel.send(nil)
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
