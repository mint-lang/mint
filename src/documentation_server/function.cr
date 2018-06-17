module Mint
  class DocumentationServer
    def generate(node : Ast::Function, json : JSON::Builder)
      json.object do
        json.field "description", node.comment.try(&.value)
        json.field "name", node.name.value
        json.field "type", stringify(node.type)
        json.field "source", source(node)
        json.field "arguments" do
          generate node.arguments, json
        end
      end
    end
  end
end
