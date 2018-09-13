module Mint
  class Ast
    class Component < Node
      getter properties, connects, styles, states, comments, inline_comments, block_comments
      getter functions, gets, uses, name, comment, inline_comment, block_comment

      def initialize(@properties : Array(Property),
                     @functions : Array(Function),
                     @comments : Array(Comment),
		     @inline_comments : Array(InlineComment),
		     @block_comments : Array(BlockComment),
                     @connects : Array(Connect),
                     @states : Array(State),
                     @styles : Array(Style),
                     @comment : Comment?,
		     @inline_comment : InlineComment?,
		     @block_comment : BlockComment?,
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
