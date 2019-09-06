module Mint
  class DocumentationServer
    @asts : Hash(MintJson, Ast) = {} of MintJson => Ast
    @formatter = Formatter.new(Ast.new)
    @error : String | Nil = nil
    @ast : Ast = Ast.new

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
        generate
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

    def generate
      current =
        MintJson.parse_current

      JSON.build do |json|
        json.object do
          json.field "packages" do
            json.array do
              generate current, @ast, json

              @asts.each do |package, ast|
                generate package, ast, json
              end
            end
          end
        end
      end
    end

    def generate(node : Ast::Node, json)
    end

    def generate(mint_json, ast : Ast, json)
      json.object do
        json.field "name", mint_json.name

        json.field "dependencies" do
          json.array do
            mint_json.dependencies.each do |dependency|
              json.object do
                json.field "name", dependency.name
                json.field "repository", dependency.repository
                json.field "constraint", dependency.constraint.to_s
              end
            end
          end
        end

        json.field "components" do
          generate ast.components.sort_by(&.name), json
        end

        json.field "stores" do
          generate ast.stores.sort_by(&.name), json
        end

        json.field "modules" do
          generate ast.modules.sort_by(&.name), json
        end

        json.field "providers" do
          generate ast.providers.sort_by(&.name), json
        end

        json.field "records" do
          generate ast.records.sort_by(&.name), json
        end

        json.field "enums" do
          generate ast.enums.sort_by(&.name), json
        end
      end
    end

    def stringify(node : Ast::Node)
      ""
    end

    def stringify(nodes : Array(Ast::Node))
      nodes.map { |node| stringify node }.join(", ")
    end

    def generate(nodes : Array(Ast::Node), json : JSON::Builder)
      json.array { nodes.each { |node| generate node, json } }
    end

    def source(node)
      @formatter.source(node)
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
