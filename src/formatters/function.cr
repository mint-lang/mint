module Mint
  class Formatter
    def format(node : Ast::Block) : String
      list node.statements
    end

    def format(node : Ast::Function) : String
      name =
        format node.name

      type =
        node.type.try do |item|
          ": #{format(item)}"
        end

      body =
        list [node.body] + node.head_comments + node.tail_comments

      arguments =
        format_arguments node.arguments

      where =
        format node.where

      comment =
        node.comment.try { |item| "#{format item}\n" }

      head =
        ["fun", name, arguments, type].compact!.join(' ')

      "#{comment}#{head} {\n#{indent(body)}\n}#{where}"
    end
  end
end
