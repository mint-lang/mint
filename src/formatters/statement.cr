module Mint
  class Formatter
    def format(node : Ast::Statement, newline = true) : Nodes
      expression =
        format node.expression

      return_call =
        format node.return_value do |item|
          [" or return "] + format(item)
        end

      if target = node.target
        target =
          format target

        if newline
          ["let "] + target + [" =", Nest.new([Line.new(1)] + expression)] + return_call
        else
          ["let "] + target + [" = "] + expression + return_call
        end
      else
        expression + return_call
      end
    end
  end
end
