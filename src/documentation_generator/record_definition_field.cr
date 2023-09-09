module Mint
  class DocumentationGeneratorJson
    def generate(node : Ast::RecordDefinitionField, json : JSON::Builder)
      json.object do
        json.field "key", node.key.value
        json.field "type", stringify(node.type)
        json.field "mapping", node.mapping.try(&.string_value)
      end
    end
  end

  class DocumentationGeneratorHtml
    def generate(node : Ast::RecordDefinitionField)
      render("#{__DIR__}/html/record_definition_field.ecr")
    end

    def stringify(node : Ast::RecordDefinitionField)
      node.key.value
    end
  end
end
