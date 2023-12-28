module Mint
  class Compiler2
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
