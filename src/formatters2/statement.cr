module Mint
  class Formatter2
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
          ["let "] + target + ["=", Indent.new([:ln] + left)]
        else
          ["let "] + target + ["= "] + left
        end
      end
    end
  end
end
