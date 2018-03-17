class Ast
  class ArrayLiteral < Node
    getter items

    def initialize(@items : Array(Expression),
                   @input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
