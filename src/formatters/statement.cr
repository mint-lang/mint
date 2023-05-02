module Mint
  class Formatter
    def format(node : Ast::Statement, newline = true) : String
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

        if newline
          "let #{target} =\n#{indent(left)}"
        else
          "let #{target} = #{left}"
        end
      end
    end
  end
end
