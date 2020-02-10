module Mint
  class Formatter
    def format(node : Ast::Constant) : String
      value =
        format node.value

      name =
        format node.name

      comment =
        node.comment.try { |item| "#{format item}\n" }

      if ast.has_new_line?(node, node.value)
        "#{comment}constant #{name} =\n#{indent(value)}"
      else
        "#{comment}constant #{name} = #{value}"
      end
    end
  end
end
