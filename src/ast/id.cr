module Mint
  class Ast
    class Id < Node
      getter value

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @value : String)
      end
    end
  end
end
