module Mint
  class DocumentationGeneratorJson
    def generate(node : Ast::Enum, json : JSON::Builder)
      json.object do
        json.field "description", node.comment.try(&.to_html)
        json.field "name" do
          generate node.name, json
        end

        json.field "parameters" do
          generate node.parameters, json
        end

        json.field "options" do
          generate node.options, json
        end
      end
    end
  end

  class DocumentationGeneratorHtml
    def generate(node : Ast::Enum)
      render("#{__DIR__}/html/enum.ecr")
    end

    def stringify(node : Ast::Enum)
      node.name.value
    end

    def comment(node : Ast::Enum)
      render("#{__DIR__}/html/comment.ecr")
    end
  end
end
