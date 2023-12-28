module Mint
  class Compiler2
    def resolve(node : Ast::Store)
      resolve node do
        functions =
          resolve node.functions

        states =
          resolve node.states

        gets =
          resolve node.gets

        constants =
          resolve node.constants

        add states + gets + functions + constants
      end
    end
  end
end
