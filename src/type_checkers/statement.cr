module Mint
  class TypeChecker
    def check(node : Ast::Statement) : Checkable
      type =
        resolve node.expression

      type =
        type.parameters.first if node.await && type.name == "Promise"

      destructure(node.target, type)

      types[node] = type
    end
  end
end
