module Mint
  class DocumentationServer
    def generate(node : Ast::State, json : JSON::Builder)
      json.object do
        json.field "type", stringify(node.type)
        json.field "data", source(node.data)
      end
    end
  end
end
