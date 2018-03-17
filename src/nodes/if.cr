class Ast
  class If < Node
    getter condition, truthy, falsy

    def initialize(@condition : Expression,
                   @truthy : Expression,
                   @falsy : Expression,
                   @input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
