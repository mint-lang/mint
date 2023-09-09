module Mint
  class DocumentationGeneratorJson
    def generate(node : Ast::Property, json : JSON::Builder)
      json.object do
        json.field "default", node.default.try { |item| source(item) }
        json.field "type", node.type.try { |item| stringify(item) }
        json.field "description", node.comment.try(&.to_html)
        json.field "name", node.name.value
      end
    end
  end

  class DocumentationGeneratorHtml
    def generate(node : Ast::Property)
      render("#{__DIR__}/html/property.ecr")
    end

    def default(node : Ast::Property)
      default = node.default.try { |item| source(item) }

      render("#{__DIR__}/html/default.ecr")
    end

    def stringify(node : Ast::Property)
      node.name.value
    end

    def comment(node : Ast::Property)
      render("#{__DIR__}/html/comment.ecr")
    end
  end
end
