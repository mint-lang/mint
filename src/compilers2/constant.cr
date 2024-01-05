module Mint
  class Compiler2
    def resolve(node : Ast::Constant)
      resolve node do
        {node, node, compile(node.expression)}
      end
    end
  end
end
