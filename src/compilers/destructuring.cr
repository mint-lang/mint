module Mint
  class Compiler
    def _compile_destructuring(node : Ast::Node, variable : String, condition_variable : String? = nil)
      case node
      when Ast::ArrayDestructuring
        _compile node, variable, condition_variable
      when Ast::TupleDestructuring
        _compile node, variable, condition_variable
      when Ast::EnumDestructuring
        _compile node, variable, condition_variable
      else
        # ignore
      end
    end
  end
end
