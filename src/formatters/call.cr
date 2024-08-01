module Mint
  class Formatter
    def format(node : Ast::Call) : Nodes
      format(node.expression) + format_arguments(node.arguments)
    end
  end
end
