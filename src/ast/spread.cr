module Mint
  class Ast
    class Spread < Node
      getter variable

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @variable : Node)
      end
    end
  end
end
