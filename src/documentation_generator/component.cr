module Mint
  class DocumentationGeneratorJson
    def generate(node : Ast::Component, json : JSON::Builder)
      json.object do
        json.field "description", node.comment.try(&.to_html)
        json.field "name" do
          generate node.name, json
        end

        json.field "connects" do
          generate node.connects, json
        end

        json.field "computed-properties" do
          generate node.gets, json
        end

        json.field "properties" do
          generate node.properties, json
        end

        json.field "functions" do
          generate node.functions, json
        end

        json.field "providers" do
          generate node.uses, json
        end

        json.field "states" do
          generate node.states, json
        end
      end
    end
  end

  class DocumentationGeneratorHtml
    def generate(node : Ast::Component)
      render("#{__DIR__}/html/component.ecr")
    end

    def stringify(node : Ast::Component)
      node.name.value
    end

    def children(node : Ast::Component)
      children("components", "property", node, node.properties) |
        children("components", "state", node, node.states) |
        children("components", "function", node, node.functions)
    end

    def comment(node : Ast::Node)
      render("#{__DIR__}/html/comment.ecr")
    end
  end
end
