module Mint
  class Ast
    class Statement < Node
      enum Parent
        Try
        Sequence
        Parallel
      end

      getter target, expression, parent

      def initialize(@target : Node | Nil,
                     @expression : Expression,
                     @parent : Parent,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
