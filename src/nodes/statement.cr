class Ast
  class Statement < Node
    getter name, expression

    def initialize(@expression : Expression,
                   @name : Variable | Nil,
                   @input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
