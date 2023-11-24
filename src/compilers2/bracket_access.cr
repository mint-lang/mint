module Mint
  class Compiler2
    def compile(node : Ast::BracketAccess) : Compiled
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
          accessor =
            if type.name == "Map"
              Builtin::MapAccess
            else
              Builtin::BracketAccess
            end

          js.call(accessor, [expression, index, just, nothing])
        end
      end
    end
  end
end
