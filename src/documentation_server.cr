module Mint
  class DocumentationServer
    @files : Hash(String, Proc(String)) = {} of String => Proc(String)

    def initialize(*, host, port)
      FileWorkspace.new(
        path: Path[Dir.current, "mint.json"].to_s,
        include_tests: true,
        check: Check::None,
        format: false,
        listener: ->(result : TypeChecker | Error) do
          @files =
            case result
            in TypeChecker
              StaticDocumentationGenerator.generate([result.artifacts.ast])
            in Error
              error(result)
            end
        end)

      server =
        HTTP::Server.new([HTTP::CompressHandler.new]) do |context|
          path =
            context.request.path.lstrip("/")

          # Handle the request depending on the result.
          content_type, content =
            if file = @files[path]?
              {
                MIME.from_filename?(path).to_s || "text/plain",
                file.call,
              }
            else
              {"text/html", @files["index.html"].call}
            end

          context.response.content_type = content_type
          context.response.print content
        end

      # Start the server.
      Server.run(
        server: server,
        host: host,
        port: port
      ) do |resolved_host, resolved_port|
        terminal.puts "#{COG} Development server started on http://#{resolved_host}:#{resolved_port}/"
      end
    end

    def error(error)
      {"index.html" => ->{ error.to_html }}
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
