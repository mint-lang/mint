module Mint
  class Compiler2
    def compile(node : Ast::Store) : Compiled
      compile node do
        functions =
          compile node.functions

        states =
          compile node.states

        gets =
          compile node.gets

        constants =
          compile node.constants

        @compiled << js.statements([["// #{node.name.value}"] of Item] + states + gets + functions + constants)

        [] of Item
      end
    end
  end
end
