module Mint
  class Ast
    class Field < Node
      getter key, value, comment

      def initialize(@file : Parser::File,
                     @comment : Comment?,
                     @key : Variable?,
                     @value : Node,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
