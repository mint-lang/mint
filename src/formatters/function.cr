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
        list [node.body] + node.head_comments + node.tail_comments

      arguments =
        unless node.arguments.empty?
          value =
            format node.arguments

          if value.map { |string| replace_skipped(string) }.map(&.size).sum > 50
            "(\n#{indent(value.join(",\n"))}\n)"
          else
            "(#{value.join(", ")})"
          end
        end

      where =
        format node.where

      comment =
        node.comment.try { |item| "#{format item}\n" }

      head =
        ["fun", name, arguments, type].compact.join(' ')

      "#{comment}#{head} {\n#{indent(body)}\n}#{where}"
    end
  end
end
