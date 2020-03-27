module Mint
  class Formatter
    def format(node : Ast::Pipe) : String
      argument =
        format node.argument

      expression =
        format node.expression

      "#{argument}\n|> #{expression}"
    end
  end
end
