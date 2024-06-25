module Mint
  class Ast
    class Statement < Node
      property if_node : Ast::If? = nil

      getter expression, target, await

      def initialize(@file : Parser::File,
                     @expression : Node,
                     @target : Node?,
                     @await : Bool,
                     @from : Int64,
                     @to : Int64)
      end

      def only_expression?
        case item = expression
        when ParenthesizedExpression
          item unless await || target
        end
      end
    end
  end
end
