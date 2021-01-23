module Mint
  class Formatter
    def format(node : Ast::RecordDefinition) : String
      name =
        format node.name

      fields =
        format node.fields, ",\n"

      comment =
        node.comment.try { |item| "#{format(item)}\n" }.to_s

      block_comment =
        node.block_comment.try { |item| "\n#{format(item)}" }.to_s

      "#{comment}record #{name} {\n#{indent(fields + block_comment)}\n}"
    end
  end
end
