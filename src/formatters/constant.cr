module Mint
  class Formatter
    def format(node : Ast::Constant) : String
      expression =
        format node.expression

      name =
        format node.name

      comment =
        node.comment.try { |item| "#{format item}\n" }

      if node.expression.new_line?
        "#{comment}const #{name} =\n#{indent(expression)}"
      else
        "#{comment}const #{name} = #{expression}"
      end
    end
  end
end
