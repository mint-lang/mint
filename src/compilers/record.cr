module Mint
  class Compiler
    def compile(node : Ast::Record) : String
      fields =
        compile node.fields, ",\n"

      type =
        types[node]

      name =
        underscorize type.name

      "new $$#{name}({\n#{fields.indent}\n})"
    end
  end
end
