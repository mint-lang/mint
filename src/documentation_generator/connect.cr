module Mint
  class DocumentationGenerator
    def generate(node : Ast::Connect, json : JSON::Builder)
      json.object do
        json.field "keys", node.keys.map(&.variable.value)
        json.field "store" do
          generate node.store, json
        end
      end
    end
  end
end
