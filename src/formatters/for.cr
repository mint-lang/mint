module Mint
  class Formatter
    def format(node : Ast::ForCondition) : String
      body =
        format node.condition

      " when {\n#{indent(body)}\n}"
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

      "for (#{arguments} of #{subject}) {\n#{indent(body)}\n}#{condition}"
    end
  end
end
