module Mint
  class Compiler2
    def compile(node : Ast::Module) : Compiled
      compile node do
        functions =
          compile node.functions

        constants =
          compile node.constants

        @compiled << js.statements(functions + constants)

        [] of Item
      end
    end
  end
end
