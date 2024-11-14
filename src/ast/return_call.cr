module Mint
  class Ast
    class ReturnCall < Node
      property statement : Ast::Statement? = nil

      getter expression

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @expression : Node)
      end
    end
  end
end
