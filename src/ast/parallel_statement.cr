module Mint
  class Ast
    class ParallelStatement < Node
      getter name, expression

      def initialize(@expression : Expression,
                     @name : Variable,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
