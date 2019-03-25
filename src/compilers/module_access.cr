module Mint
  class Compiler
    def _compile(node : Ast::ModuleAccess) : String
      name =
        js.class_of(lookups[node])

      case lookups[node]
      when Ast::Provider
        if (node.variable.value == "subscriptions")
          return "#{name}._subscriptions"
        end
      end

      variable =
        js.variable_of(lookups[node.variable])

      "#{name}.#{variable}"
    end
  end
end
