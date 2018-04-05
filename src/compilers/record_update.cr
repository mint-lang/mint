class Compiler
  def compile(node : Ast::RecordUpdate) : String
    variable =
      compile node.variable

    fields =
      compile node.fields, ", "

    "_update(#{variable}, { #{fields} })"
  end
end
