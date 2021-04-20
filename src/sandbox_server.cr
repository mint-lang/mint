module Mint
  class SandboxServer
    struct File
      include JSON::Serializable

      getter contents : String
      getter path : String

      def initialize(@contents, @path)
      end
    end

    struct Application
      include JSON::Serializable

      getter files : Array(File)
    end

    def initialize(@host = "0.0.0.0", @port = 8080)
      @server = HTTP::Server.new { |context| handle_request(context) }
      @formatter = Formatter.new
      @core = Core.ast
    end

    def handle_request(context)
      json =
        Application.from_json(context.request.body.try(&.gets_to_end).to_s)

      case context.request.path
      when "/compile"
        context.response.content_type = "text/html"
        context.response.print html(json)
      when "/format"
        formatted_files =
          json.files.map do |file|
            ast =
              Parser.parse(file.contents, file.path)

            formatted =
              @formatter.format(ast)

            File.new(contents: formatted, path: file.path)
          end

        context.response.content_type = "application/json"

        context.response.print({
          "files" => formatted_files,
        }.to_json)
      end
    end

    def html(json)
      ast =
        json.files.reduce(@core.dup) do |memo, file|
          memo.merge(Parser.parse(file.contents, file.path))
        end

      artifacts =
        TypeChecker.check(ast)

      runtime =
        Assets.read("runtime.js")

      script =
        Compiler.compile(artifacts, {
          relative:   false,
          optimize:   false,
          css_prefix: nil,
        })

      template =
        TreeTemplate.new(formatter: TreeTemplate::PrettyFormatter) do |t|
          t.doctype :html5

          t.html do
            t.head do
              t.meta(charset: "utf-8")

              # t.title json.application.title.to_s
            end

            t.body do
              t.script do
                t.unsafe runtime + script
              end
            end
          end
        end

      template.render
    rescue error : Error
      error.to_html
    rescue error
      "Something went wrong: #{error.message}\n\n#{error.backtrace}"
    end

    def start
      address =
        @server.bind_tcp @host, @port

      puts "Listening on http://#{address}"
      @server.listen
    end
  end
end
