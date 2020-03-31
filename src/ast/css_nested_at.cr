module Mint
  class Ast
    class CssNestedAt < Node
      getter content, body, name

      def initialize(@body : Array(Node),
                     @content : String,
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
