module Mint
  class Formatter
    def format(node : Ast::Signal) : String
      block =
        format node.block

      name =
        format node.name

      type =
        format node.type

      comment =
        node.comment.try { |item| "#{format item}\n" }

      "#{comment}signal #{name} : #{type} #{block}"
    end
  end
end
