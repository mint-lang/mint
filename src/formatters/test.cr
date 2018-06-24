module Mint
  class Formatter
    def format(node : Ast::Test) : String
      expression =
        list [node.expression] + node.head_comments + node.tail_comments

      name =
        format node.name

      "test #{name} {\n#{expression.indent}\n}"
    end
  end
end
