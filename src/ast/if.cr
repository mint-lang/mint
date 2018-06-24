module Mint
  class Ast
    class If < Node
      getter condition, truthy, falsy
      getter truthy_head_comments, truthy_tail_comments
      getter falsy_head_comments, falsy_tail_comments

      def initialize(@truthy_head_comments : Array(Comment),
                     @truthy_tail_comments : Array(Comment),
                     @falsy_head_comments : Array(Comment),
                     @falsy_tail_comments : Array(Comment),
                     @condition : Expression,
                     @truthy : Expression,
                     @falsy : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
