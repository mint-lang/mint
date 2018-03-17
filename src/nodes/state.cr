class Ast
  class State < Node
    getter data, type

    def initialize(@data : Record,
                   @input : Data,
                   @from : Int32,
                   @type : Type,
                   @to : Int32)
    end
  end
end
