module Mint
  class Formatter
    def format(node : Ast::WhereStatement) : String
      expression =
        format node.expression

      name =
        format node.name

      "#{name} =\n#{expression.indent}"
    end
  end
end
