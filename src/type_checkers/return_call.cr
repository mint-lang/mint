module Mint
  class TypeChecker
    type_error EncodeComplexType

    def check(node : Ast::ReturnCall) : Checkable
      type =
        resolve node.expression

      push_return(node)

      type
    end
  end
end
