require "./test/**"

module Mint
  class Test
    class Message
      JSON.mapping({
        type:   String,
        name:   String,
        result: String,
      })
    end

    class MyCustomLogger < Kemal::BaseLogHandler
      def call(context)
        call_next context
      end

      def write(message)
      end
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
                this.socket = new WebSocket("ws://localhost:3000/")
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

                  sessionStorage.clear()
                  localStorage.clear()

                  let result = await test.proc()

                  if (result instanceof SpecContext) {
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

    @reporter : DocumentationReporter | DotReporter

    def initialize(@flags : Cli::Test::Flags, @arguments : Cli::Test::Arguments)
      @reporter = resolve_reporter
      @channel = Channel(Nil).new
      @failed = [] of Message
      @succeeded = 0
    end

    def run
      setup_kemal
      open_page

      config = Kemal.config
      config.logger = MyCustomLogger.new
      config.setup
      config.server = HTTP::Server.new(config.host_binding, config.port, config.handlers)
      config.running = true
      config.server.try(&.listen)
    end

    def script
      file =
        @arguments.test

      ast =
        Ast.new

      sources =
        if file
          Dir.glob([file] + SourceFiles.all)
        else
          Dir.glob(SourceFiles.tests + SourceFiles.all)
        end

      sources.reduce(ast) do |memo, file|
        artifact = Parser.parse(file)

        formatted =
          Formatter.new(artifact).format

        if formatted != File.read(file)
          File.write(file, formatted)
        end

        memo.merge artifact
        memo
      end

      type_checker =
        TypeChecker.new(ast)

      type_checker.check

      Compiler.compile_with_tests type_checker.artifacts
    rescue exception : MintJson::Error | SyntaxError | TypeError
      puts exception.message
    end

    def resolve_reporter
      case @flags.reporter.downcase
      when "documentation"
        DocumentationReporter.new
      when "dot"
        DotReporter.new
      else
        raise "Invalid reporter!"
      end
    end

    def open_process(profile_directory)
      case @flags.browser.downcase
      when "firefox"
        Process.new(
          "firefox",
          args: [
            "--headless",
            "--width",
            "1920",
            "--height",
            "1080",
            "--profile",
            profile_directory,
            "http://localhost:3000",
          ]
        )
      when "chromium"
        Process.new(
          "chromium-browser",
          args: [
            "--headless",
            "--disable-gpu",
            "--remote-debugging-port=9222",
            "--profile-directory=#{profile_directory}",
            "--window-size=1920,1080",
            "http://localhost:3000",
          ]
        )
      else
        raise "Invalid browser #{@flags.browser}!"
      end
    end

    def open_browser
      profile_directory = File.join(Tempfile.dirname, Random.new.hex(5))
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
        script
      end

      ws "/" do |socket|
        socket.on_message do |message|
          if message == "DONE"
            @reporter.done
            sum = @succeeded + @failed.size

            puts Terminal.separator
            puts "#{sum} tests"
            puts "  #{Terminal.arrow} #{@succeeded} passed"
            puts "  #{Terminal.arrow} #{@failed.size} failed"

            @failed.each do |message|
              puts "    #{message.name}".colorize(:red).to_s
            end

            Kemal.config.server.try(&.close) unless @flags.keep_alive
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
  end
end
