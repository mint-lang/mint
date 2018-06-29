module Mint
  class DocumentationServer
    def generate(node : Ast::Enum, json : JSON::Builder)
      json.object do
        json.field "description", node.comment.try(&.to_html)
        json.field "name", node.name

        json.field "options" do
          generate node.options, json
        end
      end
    end
  end
end
