module Mint
  class Formatter
    def format(node : Ast::Field) : Nodes
      comment =
        format_documentation_comment node.comment

      value =
        format node.value

      key =
        format node.key

      body =
        if node.key
          break_not_fits(
            items: {key, value},
            separator: ":")
        else
          value
        end

      comment + body
    end
  end
end
