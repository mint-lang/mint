module Mint
  class DocumentationGeneratorJson
    def stringify(node : Ast::TypeVariable)
      node.value
    end

    def generate(node : Ast::TypeVariable, json : JSON::Builder)
      json.string node.value
    end
  end

  class DocumentationGeneratorHtml
    def generate(node : Ast::TypeVariable)
      render("#{__DIR__}/html/type_variable.ecr")
    end

    def stringify(node : Ast::TypeVariable)
      node.value
    end
  end
end
