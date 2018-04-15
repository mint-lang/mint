class Compiler
  def compile(node : Ast::Record) : String
    fields =
      compile node.fields, ",\n"

    "new Record({\n#{fields.indent}\n})"
  end
end
