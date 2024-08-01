module Mint
  class Formatter
    def format(node : Ast::Statement, newline = true) : Nodes
      expression =
        format node.expression

      left =
        if node.await
          ["await "] + expression
        else
          expression
        end

      case node.target
      when Nil
        left
      else
        target =
          format node.target

        if newline
          ["let "] + target + [" =", Nest.new([Line.new(1)] + left)]
        else
          ["let "] + target + [" = "] + left
        end
      end
    end
  end
end
