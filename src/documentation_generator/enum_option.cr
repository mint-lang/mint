module Mint
  class DocumentationGeneratorJson
    def generate(node : Ast::EnumOption, json : JSON::Builder)
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

  class DocumentationGeneratorHtml
    def generate(node : Ast::EnumOption)
      render("#{__DIR__}/html/enum_option.ecr")
    end

    def generate(node : Ast::Type, option : Ast::EnumOption)
      render("#{__DIR__}/html/enum_parameter.ecr")
    end

    def comment(node : Ast::EnumOption)
      render("#{__DIR__}/html/comment.ecr")
    end
    
    def stringify(node : Ast::EnumOption)
      node.value.value
    end 
  end
end
