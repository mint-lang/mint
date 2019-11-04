module Mint
  class DocumentationGenerator
    def generate(node : Ast::Enum, json : JSON::Builder)
      json.object do
        json.field "description", node.comment.try(&.to_html)
        json.field "name", node.name

        json.field "parameters" do
          generate node.parameters, json
        end

        json.field "options" do
          generate node.options, json
        end
      end
    end
  end
end
