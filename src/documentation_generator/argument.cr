module Mint
  class DocumentationGeneratorJson
    def generate(node : Ast::Argument, json : JSON::Builder)
      json.object do
        json.field "type", stringify(node.type)
        json.field "name", node.name.value
      end
    end
  end

  class DocumentationGeneratorHtml
    def generate(node : Ast::Argument)
      # render("#{__DIR__}/html/argument.ecr")
    end

    def stringify(node : Ast::Argument)
      node.name.value
    end
  end
end
