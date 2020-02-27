module Mint
  class Formatter
    def format(node : Ast::WhereStatement) : String
      expression =
        format node.expression

      target =
        format node.target

      "#{target} =\n#{indent(expression)}"
    end
  end
end
