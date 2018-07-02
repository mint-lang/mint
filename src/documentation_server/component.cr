module Mint
  class DocumentationServer
    def generate(node : Ast::Component, json : JSON::Builder)
      state =
        node.states.first?

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

        json.field "state" do
          if state
            generate state, json
          else
            json.null
          end
        end
      end
    end
  end
end
