module Mint
  class DocumentationGeneratorJson
    def stringify(node : Ast::Type)
      parameters =
        unless node.parameters.empty?
          "(#{stringify(node.parameters)})"
        end

      "#{stringify node.name}#{parameters}"
    end

    def generate(node : Ast::Type, json : JSON::Builder)
      json.string stringify(node)
    end
  end

  class DocumentationGeneratorHtml
    def stringify(node : Ast::Type)
      parameters =
        unless node.parameters.empty?
          "(#{stringify(node.parameters)})"
        end

      "#{stringify node.name}#{parameters}"
    end

    def generate(node : Ast::Type | Nil)
      if node
        render("#{__DIR__}/html/type.ecr")
      else
        ""
      end
    end
  end
end
