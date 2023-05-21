module Mint
  class Ast
    class TupleDestructuring < Node
      getter parameters

      def initialize(@parameters : Array(Node),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      def exhaustive?
        parameters.all?(Ast::Variable)
      end
    end
  end
end
