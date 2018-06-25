module Mint
  class DocumentationServer
    def generate(node : Ast::Get, json : JSON::Builder)
      json.object do
        json.field "name", node.name.value
        json.field "description", node.comment.try(&.to_html)
        json.field "type", stringify(node.type)
        json.field "source", source(node)
      end
    end
  end
end
