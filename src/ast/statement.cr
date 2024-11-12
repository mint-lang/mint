module Mint
  class Ast
    class Statement < Node
      property if_node : Ast::If? = nil

      getter return_value, expression, target

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @return_value : Node?,
                     @file : Parser::File,
                     @expression : Node,
                     @target : Node?)
      end

      def only_expression?
        case item = expression
        when ParenthesizedExpression
          item unless target
        end
      end
    end
  end
end
