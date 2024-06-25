module Mint
  class DocumentationGeneratorJson
    def generate(node : Ast::TypeVariant, json : JSON::Builder)
      json.object do
        json.field "description", node.comment.try(&.to_html)
        json.field "name" do
          generate node.value, json
        end

        json.field "parameters" do
          generate node.parameters, json
        end
      end
    end
  end

  class DocumentationGeneratorHtml
    def generate(node : Ast::TypeVariant)
      render("#{__DIR__}/html/type_variant.ecr")
    end

    def comment(node : Ast::TypeVariant)
      render("#{__DIR__}/html/comment.ecr")
    end

    def stringify(node : Ast::TypeVariant)
      node.value.value
    end
  end
end
