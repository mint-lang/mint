module Mint
  class Formatter
    def format(node : Ast::Statement) : String
      expression =
        format node.expression

      right =
        case node.target
        when Nil
          expression
        else
          target =
            format node.target

          "#{target} =\n#{indent(expression)}"
        end

      if node.await
        "await #{right}"
      else
        right
      end
    end
  end
end
