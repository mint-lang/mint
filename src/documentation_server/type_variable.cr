module Mint
  class DocumentationServer
    def stringify(node : Ast::TypeVariable)
      node.value
    end
  end
end
