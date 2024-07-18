module Mint
  class Formatter
    def format(node : Ast::Pipe) : String
      argument =
        format node.argument

      expression =
        format node.expression

      await =
        if node.await
          "await "
        end

      "#{argument}\n|> #{await}#{expression}"
    end
  end
end
