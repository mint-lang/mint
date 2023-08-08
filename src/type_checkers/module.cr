module Mint
  class TypeChecker
    def check_all(node : Ast::Module) : Checkable
      resolve node
      resolve node.functions

      VOID
    end

    def check(node : Ast::Module) : Checkable
      check_names node.functions, "module"
      check_global_names node.name.value, node

      VOID
    end
  end
end
