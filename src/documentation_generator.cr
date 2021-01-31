module Mint
  class DocumentationGenerator
    @formatter = Formatter.new

    def generate(asts : Hash(MintJson, Ast))
      JSON.build do |json|
        json.object do
          json.field "packages" do
            json.array do
              asts.each do |package, ast|
                generate package, ast, json
              end
            end
          end
        end
      end
    end

    def generate(mint_json, ast : Ast)
      JSON.build do |json|
        generate mint_json, ast, json
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
      nodes.join(", ") { |node| stringify node }
    end

    def generate(nodes : Array(Ast::Node), json : JSON::Builder)
      json.array { nodes.each { |node| generate node, json } }
    end

    def source(node)
      @formatter.source(node)
    end
  end
end
