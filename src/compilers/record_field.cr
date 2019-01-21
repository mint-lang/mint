module Mint
  class Compiler
    def _compile(node : Ast::RecordField) : String
      value =
        compile node.value

      "#{node.key.value}: #{value}"
    end
  end
end
