module Mint
  class Formatter
    def format(node : Ast::Call) : String
      expression =
        format node.expression

      arguments =
        format node.arguments

      arguments =
        if node.new_line?
          indent("\n#{arguments.join(", \n")}")
        else
          arguments.join(", ")
        end

      "#{expression}(#{arguments})"
    end
  end
end
