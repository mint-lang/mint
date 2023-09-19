module Mint
  class Ast
    class For < Node
      getter subject, body, arguments, condition

      def initialize(@arguments : Array(Variable),
                     @file : Parser::File,
                     @condition : Block?,
                     @subject : Node,
                     @body : Block,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
