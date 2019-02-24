module Mint
  class Formatter
    def format(node : Ast::If) : String
      condition =
        format node.condition

      truthy =
        list [node.truthy] + node.truthy_head_comments + node.truthy_tail_comments

      falsy =
        if node.falsy.is_a?(Ast::If) &&
           node.falsy_head_comments.empty? &&
           node.falsy_tail_comments.empty?
          format node.falsy
        else
          body =
            list [node.falsy] + node.falsy_head_comments + node.falsy_tail_comments

          "{\n#{indent(body)}\n}"
        end

      condition =
        if condition.includes?("\n")
          condition
            .remove_all_leading_whitespace
            .indent(4)
            .lstrip
        else
          condition
        end

      "if (#{condition}) {\n#{indent(truthy)}\n} else #{falsy}"
    end
  end
end
