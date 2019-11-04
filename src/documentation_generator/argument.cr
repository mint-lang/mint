module Mint
  class DocumentationGenerator
    def generate(node : Ast::Argument, json : JSON::Builder)
      json.object do
        json.field "type", stringify(node.type)
        json.field "name", node.name.value
      end
    end
  end
end
