module Mint
  class Compiler
    def _compile(node : Ast::RecordUpdate) : String
      expression =
        compile node.expression

      fields =
        node.fields
          .map { |item| resolve(item) }
          .reduce({} of String => String) { |memo, item| memo.merge(item) }

      "_u(#{expression}, #{js.object(fields)})"
    end
  end
end
