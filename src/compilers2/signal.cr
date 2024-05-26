module Mint
  class Compiler2
    def resolve(node : Ast::Signal)
      resolve node do
        block =
          compile node.block

        {node, node, js.call(Builtin::Signal, [block])}
      end
    end
  end
end
