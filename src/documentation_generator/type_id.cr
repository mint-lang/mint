module Mint
  class DocumentationGenerator
    def stringify(node : Ast::TypeId)
      node.value
    end

    def generate(node : Ast::TypeId, json : JSON::Builder)
      json.string stringify(node)
    end
  end
end
