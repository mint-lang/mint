module Mint
  class DocumentationGenerator
    def generate(node : Ast::Function, json : JSON::Builder)
      json.object do
        json.field "description", node.comment.try(&.to_html)
        json.field "type", stringify(node.type)
        json.field "name", node.name.value
        json.field "source", source(node)

        json.field "arguments" do
          generate node.arguments, json
        end
      end
    end
  end
end
