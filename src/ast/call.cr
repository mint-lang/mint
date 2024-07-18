module Mint
  class Ast
    class Call < Node
      getter arguments, expression, await

      def initialize(@arguments : Array(Field),
                     @file : Parser::File,
                     @expression : Node,
                     @from : Int64,
                     @to : Int64,
                     @await : Bool? = nil)
      end
    end
  end
end
