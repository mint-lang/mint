module Mint
  class DocumentationGenerator
    def stringify(node : Ast::Type)
      parameters =
        unless node.parameters.empty?
          "(" + stringify(node.parameters) + ")"
        end

      "#{node.name}#{parameters}"
    end

    def generate(node : Ast::Type, json : JSON::Builder)
      json.string stringify(node)
    end
  end
end
