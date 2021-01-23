module Mint
  class Ast
    class HtmlExpression < Node
      getter expressions

      def initialize(@expressions : Array(Node),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      def static?
        expressions.all?(&.static?)
      end

      def static_value
        expressions.join(&.static_value)
      end
    end
  end
end
