class Ast
  class NumberLiteral < Node
    getter value, float

    def initialize(@value : Float64,
                   @input : Data,
                   @float : Bool,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
