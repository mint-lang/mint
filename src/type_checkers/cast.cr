module Mint
  class TypeChecker
    def check(node : Ast::Cast) : Checkable
      expression_type =
        resolve node.expression

      type =
        resolve node.type

      resolved =
        Comparer.compare(type, expression_type)

      error! :cast_mismatch do
        snippet "Cannot cast", expression_type
        snippet "To", type
      end unless resolved

      resolved
    end
  end
end
