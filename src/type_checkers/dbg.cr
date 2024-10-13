module Mint
  class TypeChecker
    def check(node : Ast::Dbg) : Checkable
      if expression = node.expression
        resolve(expression)
      else
        Type.new("Function", [
          Variable.new("a"),
          Variable.new("a"),
        ] of Checkable)
      end
    end
  end
end
