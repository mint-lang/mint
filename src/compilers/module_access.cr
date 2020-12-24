module Mint
  class Compiler
    def _compile(node : Ast::ModuleAccess) : Codegen::Node
      name =
        js.class_of(lookups[node])

      case lookups[node]
      when Ast::Provider
        if node.variable.value == "subscriptions"
          return Codegen.join [name, "._subscriptions"]
        end
      end

      variable =
        js.variable_of(lookups[node.variable])

      Codegen.join [name, ".", variable]
    end
  end
end
