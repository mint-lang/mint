class Ast
  class Component < Node
    getter properties, connects, styles, states,
      functions, gets, uses, name

    def initialize(@properties : Array(Property),
                   @functions : Array(Function),
                   @connects : Array(Connect),
                   @states : Array(State),
                   @styles : Array(Style),
                   @gets : Array(Get),
                   @uses : Array(Use),
                   @name : String,
                   @input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
