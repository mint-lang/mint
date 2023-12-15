module Mint
  class DocumentationGeneratorJson
    def generate(node : Ast::Function, json : JSON::Builder)
      json.object do
        json.field "type", node.type.try { |item| stringify(item) }
        json.field "description", node.comment.try(&.to_html)
        json.field "name", node.name.value
        json.field "source", source(node)

        json.field "arguments" do
          generate node.arguments, json
        end
      end
    end
  end

  class DocumentationGeneratorHtml
    def generate(node : Ast::Function)
      render("#{__DIR__}/html/function.ecr")
    end

    def stringify(node : Ast::Function)
      node.name.value
    end

    def comment(node : Ast::Function)
      render("#{__DIR__}/html/comment.ecr")
    end
  end
end
