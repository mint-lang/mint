module Mint
  class Formatter
    def format(node : Ast::WhereStatement) : String
      expression =
        format node.expression

      formatted =
        format node.variables, ", "

      "#{formatted} =\n#{indent(expression)}"
    end
  end
end
