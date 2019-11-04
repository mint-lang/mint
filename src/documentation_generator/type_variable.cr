module Mint
  class DocumentationGenerator
    def stringify(node : Ast::TypeVariable)
      node.value
    end

    def generate(node : Ast::TypeVariable, json : JSON::Builder)
      json.string node.value
    end
  end
end
