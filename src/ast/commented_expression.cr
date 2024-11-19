module Mint
  class Ast
    class CommentedExpression < Node
      getter expression, comment

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @expression : Node)
      end
    end
  end
end
