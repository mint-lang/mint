module Mint
  class Ast
    class ArrayAccess < Node
      getter index, expression

      def initialize(@file : Parser::File,
                     @expression : Node,
                     @index : Node,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
