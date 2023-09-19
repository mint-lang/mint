module Mint
  class Ast
    class Call < Node
      getter arguments, expression

      def initialize(@arguments : Array(Field),
                     @file : Parser::File,
                     @expression : Node,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
