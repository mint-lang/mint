module Mint
  class Ast
    class CssMedia < Node
      getter content, body

      def initialize(@body : Array(Node),
                     @content : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
