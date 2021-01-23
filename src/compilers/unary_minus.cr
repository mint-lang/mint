module Mint
  class Compiler
    def _compile(node : Ast::UnaryMinus) : String
      expression =
        compile node.expression

      "-(#{expression})"
    end
  end
end
