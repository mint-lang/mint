module Mint
  class Formatter
    def format(node : Ast::Tag) : Nodes
      [%('), node.value, %(')] of Node
    end
  end
end
