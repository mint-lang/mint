module Mint
  class Ast
    class UnaryMinus < Node
      getter expression, negations

      def initialize(@file : Parser::File,
                     @expression : Node,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
