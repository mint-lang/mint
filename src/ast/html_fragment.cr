module Mint
  class Ast
    class HtmlFragment < Node
      getter key, children, tag, comments

      def initialize(@children : Array(HtmlContent),
                     @comments : Array(Comment),
                     @key : HtmlAttribute?,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
