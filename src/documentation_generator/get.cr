module Mint
  class DocumentationGenerator
    def generate(node : Ast::Get, json : JSON::Builder)
      json.object do
        json.field "type", node.type.try { |item| stringify(item) }
        json.field "description", node.comment.try(&.to_html)
        json.field "name", node.name.value
        json.field "source", source(node)
      end
    end
  end
end
