module Mint
  class DocumentationGenerator
    def generate(node : Ast::Module, json : JSON::Builder)
      json.object do
        json.field "description", node.comment.try(&.to_html)
        json.field "name", node.name

        json.field "functions" do
          generate node.functions, json
        end
      end
    end
  end
end
