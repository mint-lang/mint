module Mint
  class Compiler
    def resolve(node : Ast::Store)
      resolve node do
        constants =
          resolve node.constants

        functions =
          resolve node.functions

        signals =
          resolve node.signals

        states =
          resolve node.states

        gets =
          resolve node.gets

        add signals + states + gets + functions + constants
      end
    end
  end
end
