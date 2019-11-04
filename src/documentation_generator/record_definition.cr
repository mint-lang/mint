module Mint
  class DocumentationGenerator
    def generate(node : Ast::RecordDefinition, json : JSON::Builder)
      json.object do
        json.field "description", node.comment.try(&.to_html)
        json.field "name", node.name

        json.field "fields" do
          generate node.fields, json
        end
      end
    end
  end
end
