module Mint
  class Ast
    class Statement < Node
      enum Parent
        Sequence
        None
      end

      getter target, expression, parent, await

      def initialize(@expression : Expression,
                     @parent : Parent,
                     @target : Node?,
                     @await : Bool,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
