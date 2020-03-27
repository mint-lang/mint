module Mint
  class DocumentationGenerator
    def generate(node : Ast::Property, json : JSON::Builder)
      json.object do
        json.field "default", node.default.try { |item| source(item) }
        json.field "type", node.type.try { |item| stringify(item) }
        json.field "description", node.comment.try(&.to_html)
        json.field "name", node.name.value
      end
    end
  end
end
