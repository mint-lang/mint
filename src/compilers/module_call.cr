module Mint
  class Compiler
    def _compile(node : Ast::ModuleCall) : String
      name =
        js.class_of(lookups[node])

      function =
        js.variable_of(lookups[node.function])

      arguments =
        compile node.arguments, ", "

      "#{name}.#{function}(#{arguments})"
    end
  end
end
