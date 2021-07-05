module Mint
  class Compiler
    def _compile(node : Ast::Record) : Codegen::Node
      fields =
        node.fields
          .map { |item| resolve(item) }
          .reduce({} of String => Codegen::Node) { |memo, item| memo.merge(item) }

      type =
        types[node]?

      if type
        name =
          js.class_of(type.name)

        Codegen.join ["new ", name, "(", js.object(fields), ")"]
      else
        Codegen.join ["new Record(", js.object(fields), ")"]
      end
    end
  end
end
