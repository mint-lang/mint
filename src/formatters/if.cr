module Mint
  class Formatter
    def format(node : Ast::If) : String
      condition =
        format node.condition

      truthy =
        list [node.truthy] + node.truthy_head_comments + node.truthy_tail_comments

      falsy =
        list [node.falsy] + node.falsy_head_comments + node.falsy_tail_comments

      condition =
        if condition.includes?("\n")
          condition
            .remove_all_leading_whitespace
            .indent(4)
            .lstrip
        else
          condition
        end

      "if (#{condition}) {\n#{truthy.indent}\n} else {\n#{falsy.indent}\n}"
    end
  end
end
