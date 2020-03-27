module Mint
  class Formatter
    def format(node : Ast::Call) : String
      expression =
        format node.expression

      arguments =
        format node.arguments

      arguments =
        if node.new_line?
          indent("\n" + arguments.join(", \n"))
        else
          arguments.join(", ")
        end

      safe_operator =
        node.safe ? "&" : ""

      "#{expression}#{safe_operator}(#{arguments})"
    end
  end
end
