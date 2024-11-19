module Mint
  class Ast
    class TupleLiteral < Node
      getter items

      def initialize(@items : Array(CommentedExpression),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File)
      end
    end
  end
end
