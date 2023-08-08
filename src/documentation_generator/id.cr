module Mint
  class DocumentationGenerator
    def stringify(node : Ast::Id)
      node.value
    end

    def generate(node : Ast::Id, json : JSON::Builder)
      json.string stringify(node)
    end
  end
end
