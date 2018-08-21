module Mint
  class Compiler
    def _compile(node : Ast::ModuleAccess) : String
      name =
        underscorize node.name

      variable =
        node.variable.value

      case lookups[node]
      when Ast::Function
        "$#{name}.#{variable}.bind($#{name})"
      else
        "$#{name}.#{variable}"
      end
    end
  end
end
