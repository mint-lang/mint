module Mint
  class Compiler
    def _compile(node : Ast::RecordUpdate) : String
      variable =
        compile node.variable

      fields =
        node.fields
          .map { |item| resolve(item) }
          .reduce({} of String => String) { |memo, item| memo.merge(item) }

      "_u(#{variable}, #{js.object(fields)})"
    end
  end
end
