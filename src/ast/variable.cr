module Mint
  class Ast
    class Variable < Node
      getter value

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @value : String)
      end
    end
  end
end
