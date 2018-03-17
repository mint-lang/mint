class Formatter
  def format(node : Ast::Js) : String
    if node.value.includes?("\n") || node.value.includes?("\r")
      value =
        node
          .value
          .remove_leading_whitespace
          .gsub(/`/, "\\`")

      "`\n#{value}\n`"
    else
      value =
        node
          .value
          .strip
          .gsub(/`/, "\\`")

      "`#{value}`"
    end
  end
end
