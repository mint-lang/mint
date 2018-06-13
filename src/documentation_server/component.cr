module Mint
  class DocumentationServer
    def generate(node : Ast::Component, json : JSON::Builder)
      json.object do
        json.field "name", node.name

        json.field "properties" do
          generate node.properties, json
        end

        json.field "computed-properties" do
          generate node.gets, json
        end

        json.field "functions" do
          generate node.functions, json
        end
      end
    end
  end
end
