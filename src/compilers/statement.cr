module Mint
  class Compiler
    def _compile(node : Ast::Statement) : String
      if node.parent == Ast::Statement::Parent::None && (target = node.target)
        js.const(js.variable_of(target), compile node.expression)
      else
        compile node.expression
      end
    end
  end
end
