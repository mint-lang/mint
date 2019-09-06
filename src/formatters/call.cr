module Mint
  class Formatter
    def format(node : Ast::Call) : String
      expression =
        format node.expression

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
        if (replace_skipped(expression).size + replace_skipped(joined_arguments).size) > 60
          indent("\n" + arguments.join(", \n"))
        else
          joined_arguments
        end

      safe_operator =
        node.safe ? "&" : ""

      if first
        "#{first}\n|> #{expression}#{safe_operator}(#{arguments})"
      else
        "#{expression}#{safe_operator}(#{arguments})"
      end
    end
  end
end
