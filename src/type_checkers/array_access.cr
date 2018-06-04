module Mint
  class TypeChecker
    # type_error NegatedExpressionNotBool

    def check(node : Ast::ArrayAccess) : Type
      lhs = node.lhs
      index = node.index

      case lhs
      when Ast::ArrayLiteral
        if lhs
          first = lhs.items.first
          if first
            return Type.new("Maybe", [check first])
          end
        end
      when Ast::Variable
        Type.new("Maybe", [Type.new("a")])
      end

      Type.new("Maybe", [Type.new("a")])
    end
  end
end
