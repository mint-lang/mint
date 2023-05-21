module Mint
  class Ast
    class Statement < Node
      getter target, expression, await
      property if_node : Ast::If? = nil

      delegate static?, to: @expression

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
