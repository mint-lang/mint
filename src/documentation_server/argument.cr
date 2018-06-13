module Mint
  class DocumentationServer
    def generate(node : Ast::Argument, json : JSON::Builder)
      json.object do
        json.field "name", node.name.value
        json.field "type", stringify(node.type)
      end
    end
  end
end
