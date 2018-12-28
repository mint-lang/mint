module Mint
  class Compiler
    def _compile(node : Ast::Record) : String
      fields =
        compile node.fields, ",\n"

      type =
        types[node]?

      if type
        name =
          js.class_of(node)

        "new #{name}({\n#{fields.indent}\n})"
      else
        "new Record({\n#{fields.indent}\n})"
      end
    end
  end
end
