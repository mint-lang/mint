module Mint
  class DocumentationGeneratorJson
    def generate(node : Ast::State, json : JSON::Builder)
      json.object do
        json.field "type", node.type.try { |item| stringify(item) }
        json.field "description", node.comment.try(&.to_html)
        json.field "default", source(node.default)
        json.field "name", node.name.value
      end
    end
  end

  class DocumentationGeneratorHtml
    def generate(node : Ast::State)
      render("#{__DIR__}/html/state.ecr")
    end

    def stringify(node : Ast::State)
      node.name.value
    end

    def default(node : Ast::State)
      render("#{__DIR__}/html/default.ecr")
    end

    def comment(node : Ast::State)
      render("#{__DIR__}/html/comment.ecr")
    end
  end
end
