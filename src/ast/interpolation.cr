module Mint
  class Ast
    class Interpolation < Node
      getter expression

      def initialize(@file : Parser::File,
                     @expression : Node,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
