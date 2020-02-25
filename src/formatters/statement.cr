module Mint
  class Formatter
    def format(node : Ast::Statement) : String
      expression =
        format node.expression

      if node.variables.empty?
        expression
      else
        variables =
          format node.variables, ", "

        "#{variables} =\n#{indent(expression)}"
      end
    end
  end
end
