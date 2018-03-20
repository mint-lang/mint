require "kemal"

class Cli < Admiral::Command
  class Test < Admiral::Command
    class Message
      JSON.mapping({
        type: String,
        name: String,
      })
    end

    include Mint::Logger

    PAGE = <<-HTML
    <script src="/tests"></script>
    <script>
      class TestRunner {
        constructor (tests) {
          this.socket = new WebSocket("ws://localhost:3000/")
          this.tests = tests

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
            let test = this.tests.shift()

            let result = await test.proc()
            if (result) {
              this.socket.send(JSON.stringify({ type: "SUCCEEDED", name: test.name, result: result }))
            } else {
              this.socket.send(JSON.stringify({ type: "FAILED", name: test.name, result: result }))
            }

            if (this.tests.length) {
              this.next(resolve, reject)
            } else {
              resolve()
            }
          })
        }
      }

      new TestRunner(TESTS)
    </script>
    HTML

    define_help description: "Runs the tests."

    def run
      setup_kemal
      open_page
      Kemal.run
    end

    def script
      sources = Dir.glob(SourceFiles.all)
      ast = Ast.new
      compiled = ""

      log "  #{Terminal.arrow} Parsing #{sources.size} source files... " do
        sources.reduce(ast) do |memo, file|
          memo.merge Parser.parse(file)
          memo
        end
      end

      type_checker =
        TypeChecker.new(ast)

      log "  #{Terminal.arrow} Type checking: " do
        type_checker.check
      end

      log "  #{Terminal.arrow} Compiling: " do
        compiled = Compiler.compile_with_tests type_checker.artifacts
      end

      compiled
    end

    def open_page
      fork do
        Process.run(
          "chromium-browser",
          args: ["--headless", "--disable-gpu", "--remote-debugging-port=9222", "http://localhost:3000"],
          shell: true)
      end
    end

    def setup_kemal
      get "/" do
        PAGE
      end

      get "/tests" do
        script
      end

      ws "/" do |socket|
        socket.on_message do |message|
          if message == "DONE"
            exit
          else
            data = Message.from_json(message)
            if data.type == "SUCCEEDED"
              puts data.name.colorize(:green)
            else
              puts data.name.colorize(:red)
            end
          end
        end
      end
    end
  end
end
