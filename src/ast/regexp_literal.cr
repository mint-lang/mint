module Mint
  class Ast
    class RegexpLiteral < Node
      getter value, flags

      def initialize(@file : Parser::File,
                     @value : String,
                     @flags : String,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
