module Mint
  class Ast
    class Constant < Node
      getter name, expression, comment

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @expression : Node,
                     @name : Variable)
      end
    end
  end
end
