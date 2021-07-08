module Mint
  class Formatter
    def format(node : Ast::Function) : String
      name =
        format node.name

      type =
        node.type.try do |item|
          ": #{format(item)}"
        end

      body =
        format node.body

      arguments =
        format_arguments node.arguments

      comment =
        node.comment.try { |item| "#{format item}\n" }

      head =
        ["fun", name, arguments, type].compact!.join(' ')

      "#{comment}#{head} #{body}"
    end
  end
end
