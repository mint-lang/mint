module Mint
  class Compiler2
    def compile(node : Ast::ArrayAccess) : Compiled
      compile node do
        expression =
          compile node.expression

        type =
          cache[node.expression]

        index =
          compile node.index

        if type.name == "Tuple" && node.index.is_a?(Ast::NumberLiteral)
          expression + js.array([index])
        else
          js.call(Builtin::ArrayAccess, [expression, index, just, nothing])
        end
      end
    end
  end
end
