module Mint
  class Ast
    class Spread < Node
      getter variable

      def initialize(@variable : Variable,
                     @file : Parser::File,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
