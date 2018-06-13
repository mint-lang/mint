module Mint
  class DocumentationServer
    def generate(node : Ast::Property, json : JSON::Builder)
      json.object do
        json.field "name", node.name.value
        json.field "type", stringify(node.type)
        json.field "default", source(node.default)
      end
    end
  end
end
