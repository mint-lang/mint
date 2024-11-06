module Mint
  class Ast
    class Spread < Node
      getter variable

      def initialize(@file : Parser::File,
                     @variable : Node,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
