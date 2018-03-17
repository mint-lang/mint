class Formatter
  def format(prefix : String, node : Ast::FunctionCall | Ast::ModuleCall) : String
    return "#{prefix}()" if node.arguments.empty?

    items =
      if node.piped
        first =
          format node.arguments.last

        node.arguments[0..-2]
      else
        node.arguments
      end

    arguments =
      format items

    joined_arguments =
      arguments.join(", ")

    arguments =
      if (prefix.size + joined_arguments.size) > 60
        ("\n" + arguments.join(", \n")).indent
      else
        joined_arguments
      end

    if first
      "#{first}\n|> #{prefix}(#{arguments})"
    else
      "#{prefix}(#{arguments})"
    end
  end
end
