module Mint
  class DocumentationServer
    def generate(node : Ast::Enum, json : JSON::Builder)
      json.object do
        json.field "description", node.comment.try(&.to_html)
        json.field "options", node.options.map(&.value)
        json.field "name", node.name.value
      end
    end
  end
end
