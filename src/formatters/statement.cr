module Mint
  class Formatter
    def format(node : Ast::Statement) : String
      expression =
        format node.expression

      node.variables.try do |variables|
        formatted =
          format variables, ", "

        "#{formatted} =\n#{indent(expression)}"
      end || expression
    end
  end
end
