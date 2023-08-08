module Mint
  class Ast
    class Decode < Node
      getter expression, type

      def initialize(@file : Parser::File,
                     @expression : Node?,
                     @from : Int64,
                     @type : Type,
                     @to : Int64)
      end
    end
  end
end
