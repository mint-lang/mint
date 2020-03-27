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

      head =
        "#{comment}property #{name}#{type}"

      if default
        if node.new_line?
          "#{head} =\n#{indent(default)}"
        else
          "#{head} = #{default}"
        end
      else
        head
      end
    end
  end
end
