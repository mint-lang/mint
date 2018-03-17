class Formatter
  def format(node : Ast::RecordUpdate) : String
    variable =
      format node.variable

    fields =
      format node.fields

    if node.fields.size >= 2 || fields.any?(&.includes?("\n"))
      "{ #{variable} |\n#{fields.join(",\n").indent}\n}"
    else
      "{ #{variable} | #{fields.join("")} }"
    end
  end
end
