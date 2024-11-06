module Mint
  class Formatter
    def format(node : Ast::For) : Nodes
      arguments =
        format node.arguments, ", "

      subject =
        format node.subject

      body =
        format node.body

      condition =
        format(node.condition) do |item|
          [" when "] + format(item)
        end

      ["for "] + arguments + [" of "] + subject + [" "] + body + condition
    end
  end
end
