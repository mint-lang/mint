class Ast
  class Style < Node
    getter name, definitions, selectors, medias

    def initialize(@definitions : Array(CssDefinition),
                   @selectors : Array(CssSelector),
                   @medias : Array(CssMedia),
                   @name : Variable,
                   @input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
