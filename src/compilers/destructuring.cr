module Mint
  class Compiler
    def _compile_destructuring(node : Ast::Node, variable : String) : Tuple(String, Array(String))?
      case node
      when Ast::TupleDestructuring
        _compile(node, variable)
      end
    end
  end
end
