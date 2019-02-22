module Mint
  class Formatter
    def format(node : Ast::RecordDefinition) : String
      name =
        format node.name

      fields =
        format node.fields, ",\n"

      comment =
        node.comment.try { |item| "#{format(item)}\n" }

      "#{comment}record #{name} {\n#{indent(fields)}\n}"
    end
  end
end
