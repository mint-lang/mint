module Mint
  class Compiler
    def _compile(node : Ast::ModuleAccess) : String
      name =
        js.class_of(lookups[node])

      variable =
        js.variable_of(lookups[node.variable])

      "#{name}.#{variable}"
    end
  end
end
