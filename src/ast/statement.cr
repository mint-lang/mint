module Mint
  class Ast
    class Statement < Node
      enum Parent
        Try
        Sequence
        Parallel
      end

      getter variables, expression, parent

      def initialize(@variables : Array(Variable),
                     @expression : Expression,
                     @parent : Parent,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
