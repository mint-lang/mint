module Mint
  class DocumentationServer
    @asts : Hash(MintJson, Ast) = {} of MintJson => Ast
    @error : String | Nil = nil
    @ast : Ast = Ast.new
    @generator : DocumentationGenerator = DocumentationGenerator.new

    def self.start
      new
    end

    def initialize
      core_json = MintJson.new(%({"name": "core"}), "core", "mint.json")

      @asts[core_json] = Core.ast

      SourceFiles.packages.each do |package|
        ast = Ast.new

        package.source_files.each do |file|
          ast.merge(Parser.parse(File.read(file), file))
        end

        @asts[package] = ast
      end

      @watcher =
        AstWatcher.new(->{ SourceFiles.current }, include_core: false) do |result|
          case result
          when Ast
            @ast = result
            @error = nil
          when Error
            raise result
          end
        end

      spawn do
        @watcher.watch do |result|
          case result
          when Ast
            @ast = result
            @error = nil
          when Error
            @error = result.to_html
            @ast = Ast.new
          end
        end
      end

      setup_kemal

      Server.run(name: "Documentation", port: 3002)
    end

    def setup_kemal
      get "/documentation.json" do |env|
        env.response.headers.add("Access-Control-Allow-Origin", "*")
        env.response.content_type = "application/json"
        @generator.generate @asts.merge({MintJson.parse_current => @ast})
      end

      get "/" do
        index
      end

      get "/:name" do |env|
        # Set cache to expire in 30 days.
        env.response.headers["Cache-Control"] = "max-age=2592000"

        # If there is a baked file serve that.
        begin
          Assets.read("docs-viewer/" + env.params.url["name"])
        rescue BakedFileSystem::NoSuchFileError
          index
        end
      end

      # If we didn't handle any route return the index as well.
      error 404 do |env|
        halt env, response: index, status_code: 200
      end
    end

    def index
      Assets.read("docs-viewer/index.html")
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
