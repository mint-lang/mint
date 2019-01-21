module Mint
  class Ast
    class Component < Node
      getter properties, connects, styles, states, comments
      getter functions, gets, uses, name, comment, refs

      def initialize(@refs : Array(Tuple(Variable, Node)),
                     @properties : Array(Property),
                     @functions : Array(Function),
                     @comments : Array(Comment),
                     @connects : Array(Connect),
                     @states : Array(State),
                     @styles : Array(Style),
                     @comment : Comment?,
                     @gets : Array(Get),
                     @uses : Array(Use),
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
