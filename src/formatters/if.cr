class Formatter
  def format(node : Ast::If) : String
    condition =
      format node.condition

    truthy =
      format node.truthy

    falsy =
      format node.falsy

    condition =
      if condition.includes?("\n")
        condition
          .remove_all_leading_whitespace
          .indent(4)
          .lstrip
      else
        condition
      end

    "if (#{condition}) {\n#{truthy.indent}\n} else {\n#{falsy.indent}\n}"
  end
end
