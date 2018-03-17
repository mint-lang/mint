class Compiler
  def compile(node : Ast::RecordUpdate) : String
    variable =
      compile node.variable

    fields =
      compile node.fields, ", "

    "Mint.update(#{variable}, { #{fields} })"
  end
end
