module Mint
  class Formatter
    def format(node : Ast::EnumRecordDefinition)
      if node.new_line?
        fields =
          format node.fields, ",\n"

        "\n#{indent(fields)}"
      else
        format node.fields, ", "
      end
    end
  end
end
