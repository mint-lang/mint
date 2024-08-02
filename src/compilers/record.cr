module Mint
  class Compiler
    def compile(node : Ast::Record) : Compiled
      compile node do
        fields =
          node.fields
            .map { |item| resolve(item) }
            .reduce({} of Item => Compiled) { |memo, item| memo.merge(item) }

        js.object(fields)
      end
    end
  end
end
