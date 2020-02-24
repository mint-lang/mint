module Mint
  class Ast
    class Statement < Node
      getter variables, expression

      def initialize(@variables : Array(Variable) | Nil,
                     @expression : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
