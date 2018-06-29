module Mint
  class DocumentationServer
    @formatter = Formatter.new(Ast.new)
    @error : String | Nil = nil
    @ast : Ast = Ast.new

    def self.start
      new
    end

    def initialize
      @watcher =
        AstWatcher.new(->{ SourceFiles.current }) do |result|
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
      get "/_/documentation.json" do |env|
        env.response.headers.add("Access-Control-Allow-Origin", "*")
        env.response.content_type = "application/json"
        generate
      end
    end

    def generate
      JSON.build do |json|
        json.object do
          json.field "components" do
            generate @ast.components.sort_by(&.name), json
          end

          json.field "stores" do
            generate @ast.stores.sort_by(&.name), json
          end

          json.field "modules" do
            generate @ast.modules.sort_by(&.name), json
          end

          json.field "providers" do
            generate @ast.providers.sort_by(&.name), json
          end

          json.field "records" do
            generate @ast.records.sort_by(&.name), json
          end
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
      @formatter.format(node)
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
