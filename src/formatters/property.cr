module Mint
  class Formatter
    def format(node : Ast::Property) : String
      default =
        format node.default

      name =
        format node.name

      type =
        node.type.try do |item|
          " : #{format(item)}"
        end

      comment =
        node.comment.try { |item| "#{format item}\n" }

      if node.type.try { |item| ast.new_line?(item, node.default) }
        "#{comment}property #{name}#{type} =\n#{indent(default)}"
      else
        "#{comment}property #{name}#{type} = #{default}"
      end
    end
  end
end
