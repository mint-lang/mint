module Mint
  class DocumentationGeneratorJson
    def generate(node : Ast::TypeDefinition, json : JSON::Builder)
      json.object do
        json.field "description", node.comment.try(&.to_html)
        json.field "name" do
          generate node.name, json
        end

        json.field "fields" do
          generate node.fields, json
        end
      end
    end
  end

  class DocumentationGeneratorHtml
    def generate(node : Ast::TypeDefinition)
      render("#{__DIR__}/html/type_definition.ecr")
    end

    def stringify(node : Ast::TypeDefinition)
      node.name.value
    end
  end
end
