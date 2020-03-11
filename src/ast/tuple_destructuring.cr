module Mint
  class Ast
    class TupleDestructuring < Node
      getter parameters

      def initialize(@parameters : Array(Variable),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
