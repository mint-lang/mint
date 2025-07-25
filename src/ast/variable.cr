module Mint
  class Ast
    class Variable < Node
      property? unboxed = false
      getter value

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @value : String)
      end
    end
  end
end
