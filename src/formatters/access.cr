module Mint
  class Formatter
    def format(node : Ast::Access) : String
      lhs =
        format node.lhs

      if Ast.new_line?(node.lhs, node)
        "#{lhs}\n#{indent(".#{node.field.value}")}"
      else
        "#{lhs}.#{node.field.value}"
      end
    end
  end
end
