module Mint
  class Compiler
    def _compile(node : Ast::RecordField) : String
      value =
        compile node.value

      name =
        node.key.value

      "#{name}: #{value}"
    end
  end
end
