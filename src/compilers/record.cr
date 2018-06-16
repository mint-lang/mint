module Mint
  class Compiler
    def compile(node : Ast::Record) : String
      fields =
        compile node.fields, ",\n"

      name =
        types[node]?.try(&.name)

      "new Record({\n#{fields.indent}\n}, '#{name}')"
    end
  end
end
