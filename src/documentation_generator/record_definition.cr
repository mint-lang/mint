module Mint
  class DocumentationGenerator
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
end
