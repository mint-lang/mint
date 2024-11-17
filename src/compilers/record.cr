module Mint
  class Compiler
    def compile(node : Ast::Record) : Compiled
      compile node do
        type =
          cache[node]

        fields =
          node.fields
            .map { |item| resolve(item) }
            .reduce({} of Item => Compiled) { |memo, item| memo.merge(item) }

        js.call(record(type.name), [js.object(fields)])
      end
    end
  end
end
