module Mint
  class Formatter
    def format(node : Ast::Statement, newline = true) : Nodes
      expression =
        format node.expression

      case node.target
      when Nil
        expression
      else
        target =
          format node.target

        if newline
          ["let "] + target + [" =", Nest.new([Line.new(1)] + expression)]
        else
          ["let "] + target + [" = "] + expression
        end
      end
    end
  end
end
