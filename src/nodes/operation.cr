class Ast
  class Operation < Node
    getter left, right, operator

    def initialize(@right : Expression,
                   @left : Expression,
                   @operator : String,
                   @input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
