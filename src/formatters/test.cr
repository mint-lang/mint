module Mint
  class Formatter
    def format(node : Ast::Test) : String
      expression =
        format node.expression

      name =
        format node.name

      "test #{name} {\n#{indent(expression)}\n}"
    end
  end
end
