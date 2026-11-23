module Mint
  class Compiler
    def compile(node : Ast::Defer) : Compiled
      compile node do
        # Deferred code runs on its own so no values are in scope.
        body =
          with_values({} of String => Compiled) { compile(node.body) }

        add(node, node, body)

        [Deferred.new(node)] of Item
      end
    end
  end
end
