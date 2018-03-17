class Ast
  class Provider < Node
    getter subscription, functions, name

    def initialize(@functions : Array(Function),
                   @subscription : String,
                   @name : String,
                   @input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
