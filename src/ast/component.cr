module Mint
  class Ast
    class Component < Node
      getter properties, connects, styles, states, comments
      getter functions, gets, uses, name, comment, refs, constants
      getter? global
      property hash_id : String

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
        @hash_id = Digest::MD5.hexdigest(@name)[0, 5]
      end

      def owns?(node)
        (functions + constants + states + gets + properties).includes?(node)
      end
    end
  end
end
