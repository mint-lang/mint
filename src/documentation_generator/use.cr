module Mint
  class DocumentationGenerator
    def generate(node : Ast::Use, json : JSON::Builder)
      condition =
        node.condition.try do |expression|
          source(expression)
        end

      json.object do
        json.field "provider", node.provider
        json.field "data", source(node.data)
        json.field "condition", condition
      end
    end
  end
end
