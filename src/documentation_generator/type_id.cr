module Mint
  class DocumentationGeneratorJson
    def stringify(node : Ast::TypeId)
      node.value
    end

    def generate(node : Ast::TypeId, json : JSON::Builder)
      json.string stringify(node)
    end
  end

  class DocumentationGeneratorHtml
    def stringify(node : Ast::TypeId)
      node.value
    end

    def generate(node : Ast::TypeId | Nil)
    end

    def generate(node : Ast::TypeId)
      render("#{__DIR__}/html/type_id.ecr")
    end
  end
end
