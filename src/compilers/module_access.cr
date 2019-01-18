module Mint
  class Compiler
    def _compile(node : Ast::ModuleAccess) : String
      name =
        underscorize node.name

      variable =
        node.variable.value

      "$#{name}.#{variable}"
    end
  end
end
