module Mint
  class Formatter
    def format(node : Ast::WhereStatement) : String
      expression =
        format node.expression

      name =
        format node.name

      "#{name} =\n#{indent(expression)}"
    end
  end
end
