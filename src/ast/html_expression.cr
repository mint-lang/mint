module Mint
  class Ast
    class HtmlExpression < Node
      getter expression

      delegate static?, static_value, to: @expression

      def initialize(@expression : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
