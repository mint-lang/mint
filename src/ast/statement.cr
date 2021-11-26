module Mint
  class Ast
    class Statement < Node
      getter target, expression, await

      def initialize(@expression : Expression,
                     @target : Node?,
                     @await : Bool,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
