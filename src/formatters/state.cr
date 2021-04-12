module Mint
  class Formatter
    def format(node : Ast::State) : String
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

      if type.try(&.includes?('\n')) ||
         default.includes?('\n')
        "#{comment}state #{name}#{type} =\n#{indent(default)}"
      else
        "#{comment}state #{name}#{type} = #{default}"
      end
    end
  end
end
