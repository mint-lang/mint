class Ast
  class Style < Node
    getter name, definitions, selectors

    def initialize(@definitions : Array(CssDefinition),
                   @selectors : Array(CssSelector),
                   @name : Variable,
                   @input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
