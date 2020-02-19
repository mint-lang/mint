module Mint
  class Formatter
    def format(node : Ast::Constant) : String
      value =
        format node.value

      name =
        format node.name

      comment =
        node.comment.try { |item| "#{format item}\n" }

      "#{comment}const #{name} = #{value}"
    end
  end
end
