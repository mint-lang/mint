module Mint
  class DocumentationServer
    def generate(node : Ast::State, json : JSON::Builder)
      json.object do
        json.field "description", node.comment.try(&.to_html)
        json.field "default", source(node.default)
        json.field "type", stringify(node.type)
        json.field "name", node.name.value
      end
    end
  end
end
