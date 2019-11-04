module Mint
  class DocumentationGenerator
    def generate(node : Ast::Provider, json : JSON::Builder)
      json.object do
        json.field "description", node.comment.try(&.to_html)
        json.field "subscription", node.subscription
        json.field "name", node.name

        json.field "functions" do
          generate node.functions, json
        end
      end
    end
  end
end
