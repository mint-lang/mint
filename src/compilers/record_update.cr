module Mint
  class Compiler
    def _compile(node : Ast::RecordUpdate) : String
      variable =
        compile node.variable

      fields =
        compile node.fields, ", "

      "_update(#{variable}, { #{fields} })"
    end
  end
end
