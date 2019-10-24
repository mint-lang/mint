module Mint
  class Ast
    class HtmlElement < Node
      getter attributes, children, styles, tag, comments, ref

      def initialize(@attributes : Array(HtmlAttribute),
                     @styles : Array(Variable) | Nil,
                     @children : Array(HtmlContent),
                     @comments : Array(Comment),
                     @ref : Variable | Nil,
                     @tag : Variable,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
