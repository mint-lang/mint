module Mint
  class Formatter
    def format(node : Ast::Where) : String
      statements =
        list node.statements + node.comments

      " where {\n#{indent(statements)}\n}"
    end
  end
end
