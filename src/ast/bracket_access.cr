module Mint
  class Ast
    class BracketAccess < Node
      getter index, expression

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @expression : Node,
                     @index : Node)
      end
    end
  end
end
