module Mint
  class Compiler
    def _compile(node : Ast::Record) : String
      fields =
        node.fields
          .map { |item| resolve(item) }
          .reduce({} of String => String) { |memo, item| memo.merge(item) }

      type =
        types[node]?

      if type
        name =
          js.class_of(type.name)

        "new #{name}(#{js.object(fields)})"
      else
        "new Record(#{js.object(fields)})"
      end
    end
  end
end
