module Mint
  class Compiler
    def compile(node : Ast::Argument) : Compiled
      compile node do
        if default = node.default
          js.assign(node, compile(default))
        else
          [node] of Item
        end
      end
    end
  end
end
