module Mint
  class Ast
    class HtmlElement < Node
      getter attributes, children, style, tag

      def initialize(@attributes : Array(HtmlAttribute),
                     @children : Array(HtmlContent),
                     @style : Variable | Nil,
                     @tag : Variable,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
