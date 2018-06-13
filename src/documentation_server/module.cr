module Mint
  class DocumentationServer
    def generate(node : Ast::Module, json : JSON::Builder)
      json.object do
        json.field "name", node.name

        json.field "functions" do
          generate node.functions, json
        end
      end
    end
  end
end
