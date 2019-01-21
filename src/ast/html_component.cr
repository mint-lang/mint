module Mint
  class Ast
    class HtmlComponent < Node
      getter attributes, children, component, comments, ref

      def initialize(@attributes : Array(HtmlAttribute),
                     @children : Array(HtmlContent),
                     @comments : Array(Comment),
                     @ref : Variable | Nil,
                     @component : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
