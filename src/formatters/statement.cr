module Mint
  class Formatter
    def format(node : Ast::Statement) : String
      expression =
        format node.expression

      case node.target
      when Nil
        expression
      else
        target =
          format node.target

        "#{target} =\n#{indent(expression)}"
      end
    end
  end
end
