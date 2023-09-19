module Mint
  class DocumentationGeneratorJson
    def generate(node : Ast::TypeDefinitionField, json : JSON::Builder)
      json.object do
        json.field "key", node.key.value
        json.field "type", stringify(node.type)
        json.field "mapping", static_value(node.mapping)
      end
    end
  end

  class DocumentationGeneratorHtml
    def generate(node : Ast::TypeDefinitionField)
      ""
    end

    def stringify(node : Ast::TypeDefinitionField)
      node.key.value
    end
  end
end
