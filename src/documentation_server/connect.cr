module Mint
  class DocumentationServer
    def generate(node : Ast::Connect, json : JSON::Builder)
      json.object do
        json.field "keys", node.keys.map(&.value)
        json.field "store", node.store
      end
    end
  end
end
