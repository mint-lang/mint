module Mint
  class Compiler2
    def compile(node : Ast::Record) : Compiled
      fields =
        node.fields
          .map { |item| resolve(item) }
          .reduce({} of Item => Compiled) { |memo, item| memo.merge(item) }

      js.object(fields)
    end
  end
end
