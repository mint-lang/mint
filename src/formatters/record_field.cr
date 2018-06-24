module Mint
  class Formatter
    def format(node : Ast::RecordField) : String
      value =
        format node.value

      key =
        format node.key

      comment =
        node.comment.try { |item| "#{format(item)}\n" }

      if value.includes?("\n")
        "#{comment}#{key} =\n#{value.indent}"
      else
        "#{comment}#{key} = #{value}"
      end
    end
  end
end
