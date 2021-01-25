module Mint
  class Formatter
    def format(node : Ast::Enum)
      name =
        format node.name

      items =
        node.options + node.comments

      body =
        list items

      comment =
        node.comment.try { |item| "#{format item}\n" }

      parameters =
        format_parameters(node.parameters)

      "#{comment}enum #{name}#{parameters} {\n#{indent(body)}\n}"
    end
  end
end
