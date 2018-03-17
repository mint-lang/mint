class Ast
  class Property < Node
    getter name, default, type

    def initialize(@default : Expression,
                   @name : Variable,
                   @input : Data,
                   @from : Int32,
                   @type : Type,
                   @to : Int32)
    end
  end
end
