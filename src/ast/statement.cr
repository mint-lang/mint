module Mint
  class Ast
    class Statement < Node
      getter target, expression, await

      delegate static?, to: @expression

      def initialize(@expression : Expression,
                     @target : Node?,
                     @await : Bool,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      def return?
        case item = expression
        when Ast::Operation
          item.operator == "or" && item.right.is_a?(Ast::ReturnCall)
        end
      end
    end
  end
end
