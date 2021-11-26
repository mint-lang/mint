module Mint
  class Formatter
    def format(node : Ast::Statement) : String
      expression =
        format node.expression

      left =
        if node.await
          "await #{expression}"
        else
          expression
        end

      case node.target
      when Nil
        left
      else
        target =
          format node.target

        "#{target} =\n#{indent(left)}"
      end
    end
  end
end
