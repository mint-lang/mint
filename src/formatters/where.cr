module Mint
  class Formatter
    def format(node : Ast::Where) : String
      statements =
        list node.statements + node.comments

      " where {\n#{statements.indent}\n}"
    end
  end
end
