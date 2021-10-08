module Mint
  class Formatter
    def format(node : Ast::Get) : String
      name =
        format node.name

      type =
        node.type.try do |item|
          " : #{format(item)}"
        end

      body =
        format node.body

      comment =
        node.comment.try { |item| "#{format(item)}\n" }

      "#{comment}get #{name}#{type} #{body}"
    end
  end
end
