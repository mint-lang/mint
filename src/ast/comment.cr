module Mint
  class Ast
    class Comment < Node
      enum Type
        Inline
        Block
      end

      getter value, type

      def initialize(@value : String,
                     @type : Type,
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
