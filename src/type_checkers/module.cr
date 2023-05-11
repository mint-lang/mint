module Mint
  class TypeChecker
    type_error ModuleEntityNameConflict

    def check_all(node : Ast::Module) : Checkable
      resolve node

      scope node do
        resolve node.functions
      end

      VOID
    end

    def check(node : Ast::Module) : Checkable
      check_names node.functions, ModuleEntityNameConflict
      check_global_names node.name.value, node

      VOID
    end
  end
end
