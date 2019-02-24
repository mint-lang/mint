module Mint
  class Formatter
    def format(node : Ast::ForCondition) : String
      body =
        list [node.condition] + node.head_comments + node.tail_comments

      " when {\n#{indent(body)}\n}"
    end

    def format(node : Ast::For) : String
      body =
        list [node.body] + node.head_comments + node.tail_comments

      subject =
        format node.subject

      arguments =
        format node.arguments, ", "

      condition =
        format node.condition

      "for (#{arguments} of #{subject}) {\n#{indent(body)}\n}#{condition}"
    end
  end
end
