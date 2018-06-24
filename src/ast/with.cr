module Mint
  class Ast
    class With < Node
      getter body, name, head_comments, tail_comments

      def initialize(@head_comments : Array(Comment),
                     @tail_comments : Array(Comment),
                     @body : Expression,
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
