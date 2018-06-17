module Mint
  class TypeChecker
    type_error ModuleEntityNameConflict

    def check(node : Ast::Module) : Checkable
      check_names node.functions, ModuleEntityNameConflict
      check_global_names node.name, node

      scope node do
        resolve node.functions
      end

      NEVER
    end
  end
end
