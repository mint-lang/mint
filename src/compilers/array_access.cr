module Mint
  class Compiler
    def _compile(node : Ast::ArrayAccess) : String
      index =
        case node.index
        when Int64
          node.index
        when Ast::Node
          compile node.index.as(Ast::Node)
        end

      "_at(#{compile node.lhs}, #{index})"
    end
  end
end
