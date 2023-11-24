module Mint
  class Compiler2
    def resolve(node : Ast::Store)
      resolve node do
        constants =
          resolve node.constants

        functions =
          resolve node.functions

        states =
          resolve node.states

        gets =
          resolve node.gets

        add states + gets + functions + constants
      end
    end
  end
end
