module Mint
  class Ast
    class Constant < Node
      getter name, expression, comment

      def initialize(@file : Parser::File,
                     @comment : Comment?,
                     @expression : Node,
                     @name : Variable,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
