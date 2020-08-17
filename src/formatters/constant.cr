module Mint
  class Formatter
    def format(node : Ast::Constant) : String
      value =
        format node.value

      name =
        format node.name

      comment =
        node.comment.try { |item| "#{format item}\n" }

      if node.value.new_line?
        "#{comment}const #{name} =\n#{indent(value)}"
      else
        "#{comment}const #{name} = #{value}"
      end
    end
  end
end
