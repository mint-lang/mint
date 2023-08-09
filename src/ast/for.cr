module Mint
  class Ast
    class For < Node
      getter subject, body, arguments, condition

      def initialize(@arguments : Array(Variable),
                     @subject : Expression,
                     @condition : Block?,
                     @body : Block,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
