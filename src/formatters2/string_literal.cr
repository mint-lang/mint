module Mint
  class Formatter2
    def format(node : Ast::StringLiteral) : Nodes
      ["\""] + format(node.value) + ["\""]
    end
  end
end
