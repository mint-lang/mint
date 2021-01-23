module Mint
  class DocumentationGenerator
    def generate(node : Ast::State, json : JSON::Builder)
      json.object do
        json.field "type", node.type.try { |item| stringify(item) }
        json.field "description", node.comment.try(&.to_html)
        json.field "default", source(node.default)
        json.field "name", node.name.value
      end
    end
  end
end
