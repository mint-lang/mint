module Mint
  class DocumentationGeneratorJson
    def generate(node : Ast::Connect, json : JSON::Builder)
      json.object do
        json.field "keys", node.keys.map(&.name.value)
        json.field "store" do
          generate node.store, json
        end
      end
    end
  end
end
