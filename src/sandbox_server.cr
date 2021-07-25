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

      def initialize(@files)
      end
    end

    class CORS
      include HTTP::Handler

      def call(context)
        context.response.headers["Access-Control-Allow-Origin"] = "*"
        context.response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, PATCH"
        context.response.headers["Access-Control-Allow-Credentials"] = "true"
        context.response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type"
        context.response.headers["Access-Control-Max-Age"] = 1.day.total_seconds.to_i.to_s

        if context.request.method.upcase == "OPTIONS"
          context.response.content_type = "text/html; charset=utf-8"
          context.response.status = :ok
        else
          call_next context
        end
      end
    end

    def initialize(@host = "0.0.0.0", @port = 8080, runtime_path : String? = nil)
      @runtime =
        if runtime_path
          raise RuntimeFileNotFound, {
            "path" => runtime_path,
          } unless ::File.exists?(runtime_path)
          ::File.read(runtime_path)
        else
          Assets.read("runtime.js")
        end
      @server = HTTP::Server.new([CORS.new]) do |context|
        handle_request(context)
      end
      @formatter = Formatter.new
      @core = Core.ast
    end

    def handle_request(context)
      json =
        Application.from_json(context.request.body.try(&.gets_to_end).to_s)

      case context.request.path
      when "/compile"
        context.response.content_type = "text/html; charset=utf-8"
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

        context.response.content_type = "application/json; charset=utf-8"
        context.response.print({
          "files" => formatted_files,
        }.to_json)
      end
    end

    def html(json)
      ast =
        json.files.reduce(@core.dup) do |memo, file|
          memo.merge Parser.parse(file.contents, file.path)
        end

      artifacts =
        TypeChecker.check(ast)

      script =
        Compiler.compile(artifacts, {
          css_prefix: nil,
          relative:   false,
          optimize:   false,
          build:      false,
        })

      <<-HTML
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
        </head>
        <body>
          <script>
            #{@runtime + script}
          </script>
        </body>
      </html>
      HTML

    rescue error : Error
      error.to_html
    rescue error
      "Something went wrong: #{error.inspect_with_backtrace}"
    end

    def start
      address =
        @server.bind_tcp @host, @port

      puts "Listening on http://#{address}"
      @server.listen
    end
  end
end
