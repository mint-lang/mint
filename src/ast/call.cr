module Mint
  class Ast
    class Call < Node
      getter arguments, expression, await

      def initialize(@arguments : Array(Field),
                     @file : Parser::File,
                     @expression : Node,
                     @await : Bool,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
