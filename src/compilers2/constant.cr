module Mint
  class Compiler2
    def resolve(node : Ast::Constant)
      {node, compile(node.expression)}
    end
  end
end
