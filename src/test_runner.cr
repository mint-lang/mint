module Mint
  class TestRunner
    class Message
      JSON.mapping({
        type:   String,
        name:   String,
        result: String,
      })
    end

    PAGE = <<-HTML
      <html>
        <head>
        </head>
        <body>
          <script src="/runtime.js"></script>
          <script src="/tests"></script>
          <script>
            class TestRunner {
              constructor (suites) {
                this.socket = new WebSocket("ws://localhost:3001/")
                this.suites = suites

                this.socket.onopen = () => {
                  this.run()
                    .then(() => this.socket.send("DONE"))
                }
              }

              async run () {
                return new Promise((resolve, reject) => {
                  this.next(resolve, reject)
                })
              }

              async next (resolve, reject) {
                requestAnimationFrame(async () => {
                  if (!this.suite || this.suite.tests.length === 0) {
                    this.suite = this.suites.shift()

                    if (this.suite) {
                      this.socket.send(JSON.stringify({ type: "SUITE", name: this.suite.name, result: "" }))
                    } else {
                      return resolve()
                    }
                  }

                  let test = this.suite.tests.shift()

                  let currentHistory = window.history.length

                  let result = await test.proc()

                  // Go back to the beginning
                  if (window.history.length - currentHistory) {
                    window.history.go(-(window.history.length - currentHistory))
                  }

                  // Clear storages
                  sessionStorage.clear()
                  localStorage.clear()

                  // TODO: Reset Stores

                  if (result instanceof Mint.TestContext) {
                    try {
                      await result.run()
                      this.socket.send(JSON.stringify({ type: "SUCCEEDED", name: test.name, result: result.subject.toString() }))
                    } catch (error) {
                      this.socket.send(JSON.stringify({ type: "FAILED", name: test.name, result: error.toString() }))
                    }
                  } else {
                    if (result) {
                      this.socket.send(JSON.stringify({ type: "SUCCEEDED", name: test.name, result: "true" }))
                    } else {
                      this.socket.send(JSON.stringify({ type: "FAILED", name: test.name, result: "false" }))
                    }
                  }

                  this.next(resolve, reject)
                })
              }
            }

            new TestRunner(SUITES)
          </script>
          <div id="root">
          </div>
        </body>
      </html>
    HTML

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

      browser_path
    end

    def run
      terminal.measure "#{COG} Ensuring dependencies... " do
        MintJson.parse_current.check_dependencies!
      end

      ast = terminal.measure "#{COG} Compiling tests... " do
        a = compile_ast
        compile_script(a)
        a
      end

      if ast.try(&.suites.empty?)
        terminal.print "\nThere are no tests to run!\n"
        return
      end

      terminal.print "#{COG} Starting test server...\n"
      setup_kemal

      terminal.print "#{COG} Starting browser...\n"
      open_page

      Server.run(name: "Test", port: 3001)
    end

    def browser_path
      if paths = BROWSER_PATHS[@flags.browser.downcase]?
        path =
          paths.find { |item| Process.run("which", args: [item]).success? }

        raise BrowserNotFound, {
          "browser" => @flags.browser,
        } unless path

        path
      else
        raise InvalidBrowser, {"browser" => @flags.browser}
      end
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

      sources.uniq.reduce(ast) do |memo, file|
        artifact = Parser.parse(file)

        formatted =
          Formatter.new(artifact, MintJson.parse_current.formatter_config).format

        if formatted != File.read(file)
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
            "http://localhost:3001",
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
            "http://localhost:3001",
          ]
        )
      else
        raise InvalidBrowser, {"browser" => @flags.browser}
      end
    end

    def open_browser
      return if @flags.manual
      profile_directory = File.join(Dir.tempdir, Random.new.hex(5))
      Dir.mkdir(profile_directory)
      process = open_process(profile_directory)
      @channel.receive
      process.kill
      FileUtils.rm_rf(profile_directory)
    end

    def open_page
      spawn { open_browser }
    end

    def setup_kemal
      get "/" do
        @failed = [] of Message
        @succeeded = 0
        PAGE
      end

      get "/runtime.js" do
        Assets.read("runtime.js").to_s
      end

      get "/tests" do
        @script
      end

      ws "/" do |socket|
        terminal.print "#{COG} Running tests:\n"

        socket.on_message do |message|
          if message == "DONE"
            @reporter.done
            sum = @succeeded + @failed.size

            terminal.divider
            puts "#{sum} tests"
            puts "  #{ARROW} #{@succeeded} passed"
            puts "  #{ARROW} #{@failed.size} failed"

            @failed.each do |faliure|
              puts "    #{faliure.name}".colorize(:red).to_s
              puts "    |> #{faliure.result}".colorize(:red).to_s
            end

            Kemal.config.server.try(&.close) unless @flags.manual
            @channel.send(nil)
          else
            data = Message.from_json(message)
            case data.type
            when "SUITE"
              @reporter.suite data.name
            when "SUCCEEDED"
              @reporter.succeeded data.name
              @succeeded += 1
            when "FAILED"
              @reporter.failed data.name, data.result
              @failed << data
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
