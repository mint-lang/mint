module Mint
  class Ast
    class BoolLiteral < Node
      getter value

      def initialize(@file : Parser::File,
                     @value : Bool,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
