module Mint
  class Ast
    class For < Node
      getter subject, body, arguments, condition

      def initialize(@condition : ForCondition?,
                     @arguments : Array(Variable),
                     @subject : Expression,
                     @body : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
