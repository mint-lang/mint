module Mint
  class Formatter
    def format(node : Ast::Property) : String
      name =
        format node.name

      type =
        node.type.try do |item|
          " : #{format(item)}"
        end

      comment =
        node.comment.try { |item| "#{format item}\n" }

      head =
        "#{comment}property #{name}#{type}"

      if default = node.default
        formatted =
          format default

        if default.new_line? || Ast.new_line?(node.name, default)
          "#{head} =\n#{indent(formatted)}"
        else
          "#{head} = #{formatted}"
        end
      else
        head
      end
    end
  end
end
