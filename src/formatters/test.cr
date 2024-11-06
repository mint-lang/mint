module Mint
  class Formatter
    def format(node : Ast::Test) : Nodes
      expression =
        format node.expression

      name =
        format node.name

      ["test "] + name + [" "] + expression
    end
  end
end
