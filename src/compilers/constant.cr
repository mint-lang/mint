module Mint
  class Compiler
    def resolve(node : Ast::Constant)
      resolve node do
        {node, node, compile(node.expression)}
      end
    end
  end
end
