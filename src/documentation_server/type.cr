module Mint
  class DocumentationServer
    def stringify(node : Ast::Type)
      parameters =
        if node.parameters.any?
          "(" + stringify(node.parameters) + ")"
        end

      "#{node.name}#{parameters}"
    end
  end
end
