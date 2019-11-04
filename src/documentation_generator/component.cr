module Mint
  class DocumentationGenerator
    def generate(node : Ast::Component, json : JSON::Builder)
      json.object do
        json.field "description", node.comment.try(&.to_html)
        json.field "name", node.name

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
end
