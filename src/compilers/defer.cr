module Mint
  class Compiler
    def compile(node : Ast::Defer) : Compiled
      compile node do
        add(node, node, compile(node.body))

        [Deferred.new(node)] of Item
      end
    end
  end
end
