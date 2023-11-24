module Mint
  class Compiler2
    def compile(node : Ast::RecordUpdate) : Compiled
      compile node do
        expression =
          compile node.expression

        fields =
          node.fields
            .map { |item| resolve(item) }
            .reduce({} of String => Compiled) { |memo, item| memo.merge(item) }
            .map { |key, value| [key, ": "] + value }

        fields.unshift(["..."] + expression)

        js.object_destructuring(fields)
      end
    end
  end
end
