module Mint
  class Compiler
    def _compile(node : Ast::Statement) : String
      right = compile node.expression
      right = "await #{right}" if node.await

      if node.parent == Ast::Statement::Parent::None && (target = node.target)
        js.const js.variable_of(target), right
      else
        right
      end
    end
  end
end
