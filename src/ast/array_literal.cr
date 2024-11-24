module Mint
  class Ast
    class ArrayLiteral < Node
      getter comment, items, type

      def initialize(@items : Array(CommentedExpression),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @type : Node?)
      end
    end
  end
end
