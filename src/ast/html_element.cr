module Mint
  class Ast
    class HtmlElement < Node
      getter attributes, children, style, tag, comments, ref

      def initialize(@attributes : Array(HtmlAttribute),
                     @children : Array(HtmlContent),
                     @comments : Array(Comment),
                     @style : Variable | Nil,
                     @ref : Variable | Nil,
                     @tag : Variable,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
