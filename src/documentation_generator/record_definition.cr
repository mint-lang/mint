module Mint
  class DocumentationGeneratorJson
    def generate(node : Ast::RecordDefinition, json : JSON::Builder)
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
    def generate(node : Ast::RecordDefinition)
      render("#{__DIR__}/html/record_definition.ecr")
    end

    def stringify(node : Ast::RecordDefinition)
      node.name.value
    end
  end
end
