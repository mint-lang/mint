module Mint
  class Ast
    class TupleLiteral < Node
      getter comment, items

      def initialize(@items : Array(CommentedExpression),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?)
      end
    end
  end
end
