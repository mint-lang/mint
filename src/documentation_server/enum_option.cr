module Mint
  class DocumentationServer
    def generate(node : Ast::EnumOption, json : JSON::Builder)
      json.object do
        json.field "description", node.comment.try(&.to_html)
        json.field "name", node.value
      end
    end
  end
end
