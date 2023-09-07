module Mint
  class DocumentationGeneratorJson
    def generate(node : Ast::Provider, json : JSON::Builder)
      json.object do
        json.field "description", node.comment.try(&.to_html)
        json.field "subscription", node.subscription.value
        json.field "name" do
          generate node.name, json
        end

        json.field "functions" do
          generate node.functions, json
        end
      end
    end
  end

  class DocumentationGeneratorHtml
    def generate(node : Ast::Provider)
      render("#{__DIR__}/html/provider.ecr")
    end
  end
end
