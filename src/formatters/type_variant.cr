module Mint
  class Formatter
    def format(node : Ast::TypeVariant)
      comment =
        node.comment.try { |item| "#{format item}\n" }

      parameters =
        if (fields = node.fields) && fields.size > 0 && node.new_line?
          items =
            format fields, ",\n"

          "(\n#{indent(items)})"
        else
          format_parameters(node.parameters)
        end

      "#{comment}#{format node.value}#{parameters}"
    end
  end
end
