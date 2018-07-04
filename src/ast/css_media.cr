module Mint
  class Ast
    class CssMedia < Node
      getter content, definitions, comments

      def initialize(@definitions : Array(CssDefinition),
                     @comments : Array(Comment),
                     @content : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
