module Mint
  class Ast
    class Comment < Node
      getter value

      def initialize(@value : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      def to_html
        Markd.to_html(value)
      end
    end
  end
end
