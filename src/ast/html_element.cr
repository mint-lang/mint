module Mint
  class Ast
    class HtmlElement < Node
      getter attributes, children, styles, tag, comments, ref
      getter closing_tag_position

      property? in_component : Bool = false

      def initialize(@attributes : Array(HtmlAttribute),
                     @closing_tag_position : Int64?,
                     @comments : Array(Comment),
                     @styles : Array(HtmlStyle),
                     @children : Array(Node),
                     @file : Parser::File,
                     @ref : Variable?,
                     @tag : Variable,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
