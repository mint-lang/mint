module Mint
  class Compiler
    def _compile(node : Ast::ArrayAccess) : String
      type =
        cache[node.lhs]

      lhs =
        compile node.lhs

      index =
        case node.index
        when Int64
          node.index
        when Ast::Node
          compile node.index.as(Ast::Node)
        end

      if type.name == "Tuple" && node.index.is_a?(Int64)
        "#{lhs}[#{index}]"
      else
        "_at(#{lhs}, #{index})"
      end
    end
  end
end
