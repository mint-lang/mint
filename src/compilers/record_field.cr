module Mint
  class Compiler
    def _compile(node : Ast::RecordField) : String
      value =
        compile node.value

      name =
        js.variable_of(node)

      "#{name}: #{value}"
    end
  end
end
