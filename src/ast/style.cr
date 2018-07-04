module Mint
  class Ast
    class Style < Node
      getter name, definitions, selectors, medias, comments

      def initialize(@definitions : Array(CssDefinition),
                     @selectors : Array(CssSelector),
                     @comments : Array(Comment),
                     @medias : Array(CssMedia),
                     @name : Variable,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
