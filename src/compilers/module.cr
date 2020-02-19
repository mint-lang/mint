module Mint
  class Compiler
    def _compile(node : Ast::Module) : String
      name =
        js.class_of(node)

      functions =
        compile node.functions

      constants =
        compile node.constants

      js.module(name, constants + functions)
    end
  end
end
