require "kemal"

class Cli < Admiral::Command
  class Test < Admiral::Command
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

    include Mint::Logger
    include Command

    define_flag keep_alive : Bool,
      description: "Wether or not keep alive the testing server after",
      long: "keep-alive",
      default: false,
      short: "k"

    PAGE = <<-HTML
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
    HTML

    define_help description: "Runs the tests."

    @succeeded = 0
    @failed = 0
    @process : Process?
    @channel = Channel(Nil).new

    def run
      execute "Running tests" do
        setup_kemal
        open_page

        config = Kemal.config
        config.logger = MyCustomLogger.new
        config.setup
        config.server = HTTP::Server.new(config.host_binding, config.port, config.handlers)
        config.running = true
        config.server.try(&.listen)
      end
    end

    def script
      sources = Dir.glob(SourceFiles.all)
      ast = Ast.new

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
    end

    def open_page
      spawn do
        profile_directory = File.join(Tempfile.dirname, Random.new.hex(5))
        Dir.mkdir(profile_directory)

        # process = Process.new(
        #   "firefox",
        #   args: ["--headless", "--profile", profile_directory, "http://localhost:3000"])

        process = Process.new(
          "chromium-browser",
          args: ["--headless", "--disable-gpu", "--remote-debugging-port=9222", "--profile-directory=#{profile_directory}", "http://localhost:3000"])
        @channel.receive
        process.kill
        FileUtils.rm_rf(profile_directory)
      end
    end

    def setup_kemal
      get "/" do
        @succeeded = 0
        @failed = 0
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
            sum = @succeeded + @failed

            puts Terminal.separator
            puts "#{sum} tests"
            puts "  #{Terminal.arrow} #{@succeeded} passed"
            puts "  #{Terminal.arrow} #{@failed} failed"

            Kemal.config.server.try(&.close) unless flags.keep_alive
            @channel.send(nil)
          else
            data = Message.from_json(message)
            case data.type
            when "SUITE"
              puts data.name
            when "SUCCEEDED"
              puts "✔ #{data.name}".colorize(:green).to_s.indent
              @succeeded += 1
            when "FAILED"
              puts "✘ #{data.name}".colorize(:red).to_s.indent
              puts data.result.colorize(:red).to_s.indent(4)
              @failed += 1
            end
          end
        end
      end
    end
  end
end
