class Compiler
  def compile(node : Ast::Record) : String
    fields =
      compile node.fields, ",\n"

    "{\n#{fields.indent}\n}"
  end
end
