module Mint
  class Formatter
    def format(node : Ast::ForCondition) : String
      body =
        format node.condition

      " when #{body}"
    end

    def format(node : Ast::For) : String
      body =
        format node.body

      subject =
        format node.subject

      arguments =
        format node.arguments, ", "

      condition =
        format node.condition

      "for (#{arguments} of #{subject}) #{body}#{condition}"
    end
  end
end
