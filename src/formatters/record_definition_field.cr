class Formatter
  def format(node : Ast::RecordDefinitionField) : String
    key =
      format node.key

    type =
      format node.type

    "#{key} : #{type}"
  end
end
