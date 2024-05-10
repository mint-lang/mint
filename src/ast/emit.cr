module Mint
  class Ast
    class Emit < Node
      property signal : Signal? = nil
      getter expression

      def initialize(@file : Parser::File,
                     @expression : Node,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
