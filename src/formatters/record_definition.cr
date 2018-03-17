class Formatter
  def format(node : Ast::RecordDefinition) : String
    name =
      format node.name

    fields =
      format node.fields, ",\n"

    "record #{name} {\n#{fields.indent}\n}"
  end
end
