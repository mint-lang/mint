module Mint
  class Ast
    class TupleDestructuring < Node
      alias TupleDestructuringParameter = DestructuringType | Variable

      getter parameters

      def initialize(@parameters : Array(TupleDestructuringParameter),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
