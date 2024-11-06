module Mint
  class Ast
    class MapField < Node
      getter key, value, comment

      def initialize(@file : Parser::File,
                     @comment : Comment?,
                     @from : Int64,
                     @value : Node,
                     @key : Node,
                     @to : Int64)
      end
    end
  end
end
