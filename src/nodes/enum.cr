class Ast
  class Enum < Node
    getter options, name

    def initialize(@options : Array(String),
                   @name : String,
                   @input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
