module Mint
  class Ast
    class CssSelector < Node
      getter selectors, definitions, comments

      def initialize(@definitions : Array(CssDefinition),
                     @comments : Array(Comment),
                     @selectors : Array(String),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
