module Mint
  class Ast
    class ArrayLiteral < Node
      getter items, type

      def initialize(@items : Array(CommentedExpression),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @type : Node?)
      end
    end
  end
end
