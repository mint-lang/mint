module Mint
  class Formatter
    def format(node : Ast::Property) : String
      default =
        format node.default

      name =
        format node.name

      type =
        format node.type

      comment =
        node.comment.try { |item| "#{format item}\n" }

      if ast.has_new_line?(node.type, node.default)
        "#{comment}property #{name} : #{type} =\n#{indent(default)}"
      else
        "#{comment}property #{name} : #{type} = #{default}"
      end
    end
  end
end
