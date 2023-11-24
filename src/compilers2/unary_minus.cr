module Mint
  class Compiler2
    def compile(node : Ast::UnaryMinus) : Compiled
      expression =
        compile node.expression

      ["-("] + expression + [")"]
    end
  end
end
