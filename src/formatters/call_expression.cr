module Mint
  class Formatter
    def format(node : Ast::CallExpression)
      expression =
        format node.expression

      if name = node.name
        "#{name.value}: #{expression}"
      else
        expression
      end
    end
  end
end
