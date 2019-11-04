module Mint
  class DocumentationGenerator
    def generate(node : Ast::EnumOption, json : JSON::Builder)
      json.object do
        json.field "description", node.comment.try(&.to_html)
        json.field "name", node.value

        json.field "parameters" do
          generate node.parameters, json
        end
      end
    end
  end
end
