module Mint
  class Ast
    class If < Node
      getter truthy_head_comments, truthy_tail_comments
      getter falsy_head_comments, falsy_tail_comments
      getter condition, branches

      alias Branches = Tuple(Array(CssDefinition), Array(CssDefinition)) |
                       Tuple(Array(CssDefinition), Nil) |
                       Tuple(Array(CssDefinition), If) |
                       Tuple(Node, Node)

      def initialize(@truthy_head_comments : Array(Comment),
                     @truthy_tail_comments : Array(Comment),
                     @falsy_head_comments : Array(Comment),
                     @falsy_tail_comments : Array(Comment),
                     @branches : Branches,
                     @condition : Node,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
