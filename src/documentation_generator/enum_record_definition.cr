module Mint
  class DocumentationGeneratorJson
    def generate(node : Ast::EnumRecordDefinition, json : JSON::Builder)
      json.object do
        json.field "fields" do
          generate node.fields, json
        end
      end
    end
  end

  class DocumentationGeneratorHtml
    def generate(node : Ast::EnumRecordDefinition)
      render("#{__DIR__}/html/enum_record_definition.ecr")
    end
  end
end