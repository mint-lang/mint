module Mint
  class Ast
    class Block < Node
      getter expressions, returns

      def initialize(@returns : Array(ReturnCall),
                     @expressions : Array(Node),
                     @file : Parser::File,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
