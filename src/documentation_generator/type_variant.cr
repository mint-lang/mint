module Mint
  class DocumentationGenerator
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
end
