module Mint
  class Formatter2
    def format(node : Ast::Field) : Nodes
      value =
        format node.value

      key =
        format node.key

      comment =
        documentation_comment(node.comment)

      body =
        if node.key
          [
            Group.new(
              items: [key, value],
              separator: ":",
              ends: {"", ""}),
          ] of Node
        else
          value
        end

      comment + body
    end
  end
end
