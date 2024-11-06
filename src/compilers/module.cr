module Mint
  class Compiler
    def resolve(node : Ast::Module)
      resolve node do
        functions =
          resolve node.functions

        constants =
          resolve node.constants

        add functions + constants
      end
    end
  end
end
