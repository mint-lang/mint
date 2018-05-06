module Mint
  class Ast
    class CssMedia < Node
      getter content, definitions

      def initialize(@definitions : Array(CssDefinition),
                     @content : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
