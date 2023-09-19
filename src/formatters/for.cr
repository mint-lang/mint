module Mint
  class Formatter
    def format(node : Ast::For) : String
      body =
        format node.body

      subject =
        format node.subject

      arguments =
        format node.arguments, ", "

      condition =
        if item = node.condition
          " when #{format(item)}"
        end

      "for #{arguments} of #{subject} #{body}#{condition}"
    end
  end
end
