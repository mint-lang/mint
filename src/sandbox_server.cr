module Mint
  class SandboxServer
    # Represents a source file.
    struct File
      include JSON::Serializable

      getter contents : String
      getter path : String

      def initialize(@contents, @path)
      end
    end

    # Represents a project.
    struct Project
      include JSON::Serializable

      @[JSON::Field(key: "activeFile")]
      getter active_file : String
      getter files : Array(File)

      def initialize(@files, @active_file)
      end
    end

    # A handler for allowing cross origin requests.
    class CORS
      include HTTP::Handler

      def call(context)
        context.response.headers["Access-Control-Max-Age"] = 1.day.total_seconds.to_i.to_s
        context.response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, PATCH"
        context.response.headers["Access-Control-Allow-Headers"] = "Content-Type"
        context.response.headers["Access-Control-Allow-Credentials"] = "true"
        context.response.headers["Access-Control-Allow-Origin"] = "*"

        if context.request.method.upcase == "OPTIONS"
          context.response.content_type = "text/html; charset=utf-8"
          context.response.status = :ok
        else
          call_next context
        end
      end
    end

    class Ide
      class Message
        include JSON::Serializable

        property payload : JSON::Any
        property type : String
      end

      @socket : HTTP::WebSocket
      @directory : Path
      @id : String

      def initialize(@socket)
        @socket.on_message(&->handle_message(String))
        @socket.on_close { close }

        @id =
          Random::Secure.hex

        @directory =
          Path[Dir.tempdir, Random::Secure.hex]
            .tap(&->FileUtils.mkdir_p(Path))

        ::File.write(Path[@directory, "mint.json"], {
          "source-directories" => ["."],
        }.to_json)

        @workspace = Workspace.new(@directory.to_s)
        @workspace.check_everything = false
        @workspace.on "change" do |result|
          bundle =
            case result
            in Ast
              Bundler.new(
                artifacts: @workspace.type_checker.artifacts,
                json: @workspace.json,
                config: Bundler::Config.new(
                  generate_manifest: false,
                  include_program: true,
                  hash_assets: false,
                  runtime_path: nil,
                  live_reload: false,
                  skip_icons: false,
                  relative: false,
                  optimize: true,
                  test: nil),
              ).bundle
            in Error
              {"index.html" => ->{ result.to_html }}
            end

          io =
            IO::Memory.new

          Compress::Zip::Writer.open(io) do |zip|
            bundle.each do |path, contents|
              zip.add(path, contents.call)
            end
          end

          io.rewind
          HTTP::Client.post("https://#{@id}.sandbox.mint-lang.com/", body: io)
          @socket.send({type: "reload", url: "https://#{@id}.sandbox.mint-lang.com/"}.to_json)
        end
      end

      def handle_message(raw : String)
        message =
          Message.from_json(raw)

        case message.type
        when "update"
          Project.from_json(message.payload.to_json).tap do |project|
            project.files.each do |file|
              ::File.write(Path[@directory, file.path], file.contents)
            end
            @workspace.reset_cache
            highlight(project.active_file)
          end
        end
      rescue
      end

      def highlight(path)
        tokens =
          begin
            ast =
              Parser.parse(Path[@directory, path].to_s)

            SemanticTokenizer.new.tap(&.tokenize(ast)).tokens.map do |token|
              type =
                case token.type
                in SemanticTokenizer::TokenType::TypeParameter
                  :type_parameter
                in SemanticTokenizer::TokenType::Type
                  :type
                in SemanticTokenizer::TokenType::Namespace
                  :namespace
                in SemanticTokenizer::TokenType::Property
                  :property
                in SemanticTokenizer::TokenType::Keyword
                  :keyword
                in SemanticTokenizer::TokenType::Comment
                  :comment
                in SemanticTokenizer::TokenType::Variable
                  :variable
                in SemanticTokenizer::TokenType::Operator
                  :operator
                in SemanticTokenizer::TokenType::String
                  :string
                in SemanticTokenizer::TokenType::Number
                  :number
                in SemanticTokenizer::TokenType::Regexp
                  :regexp
                end

              {
                from: token.from,
                to:   token.to,
                type: type,
              }
            end
          rescue e
            [] of String
          end

        @socket.send({type: "highlight", tokens: tokens}.to_json)
      end

      def close
        FileUtils.rm_rf(@directory)
      end
    end

    def initialize(host, port)
      server =
        HTTP::Server.new(
          [
            CORS.new,
            HTTP::WebSocketHandler.new { |socket| Ide.new(socket) },
          ])

      Server.run(
        server: server,
        port: port,
        host: host
      ) do |resolved_host, resolved_port|
        terminal.puts "#{COG} Sandbox server started on http://#{resolved_host}:#{resolved_port}/"
      end
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
