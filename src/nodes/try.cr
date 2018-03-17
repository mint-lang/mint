class Ast
  class Try < Node
    getter statements, catches

    def initialize(@statements : Array(Statement),
                   @catches : Array(Catch),
                   @input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
