module Mint
  class Formatter
    def format(node : Ast::Call) : String
      expression =
        format node.expression

      return "#{expression}()" if node.arguments.empty?

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
        if (expression.size + joined_arguments.size) > 60
          indent("\n" + arguments.join(", \n"))
        else
          joined_arguments
        end

      if first
        "#{first}\n|> #{expression}(#{arguments})"
      else
        "#{expression}(#{arguments})"
      end
    end
  end
end
