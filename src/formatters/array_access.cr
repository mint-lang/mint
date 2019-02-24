module Mint
  class Formatter
    def format(node : Ast::ArrayAccess) : String
      index =
        case node.index
        when Int64
          node.index
        else
          format node.index.as(Ast::Expression)
        end

      lhs =
        format node.lhs

      "#{lhs}[#{index}]"
    end
  end
end
