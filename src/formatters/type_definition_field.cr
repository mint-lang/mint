module Mint
  class Formatter
    def format(node : Ast::TypeDefinitionField) : String
      key =
        format node.key

      type =
        format node.type

      mapping =
        node.mapping.try do |item|
          mapping_key =
            format item

          " using #{mapping_key}"
        end.to_s

      comment =
        node.comment.try { |item| "#{format(item)}\n" }

      "#{comment}#{key} : #{type}#{mapping}"
    end
  end
end
