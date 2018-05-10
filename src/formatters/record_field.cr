module Mint
  class Formatter
    def format(node : Ast::RecordField) : String
      value =
        format node.value

      key =
        format node.key

      if value.includes?("\n")
        "#{key} =\n#{value.indent}"
      else
        "#{key} = #{value}"
      end
    end
  end
end
