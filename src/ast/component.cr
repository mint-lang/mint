module Mint
  class Ast
    class Component < Node
      getter properties, connects, styles, states, comments
      getter functions, gets, uses, name, comment, refs, constants
      getter? global

      def initialize(@refs : Array(Tuple(Variable, Node)),
                     @properties : Array(Property),
                     @constants : Array(Constant),
                     @functions : Array(Function),
                     @comments : Array(Comment),
                     @connects : Array(Connect),
                     @states : Array(State),
                     @styles : Array(Style),
                     @comment : Comment?,
                     @gets : Array(Get),
                     @uses : Array(Use),
                     @global : Bool,
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      def owns?(node)
        (functions + constants + states + gets + properties).includes?(node)
      end
    end
  end
end
