module Mint
  class Ast
    class HtmlElement < Node
      getter attributes, children, comments, styles, tag, ref
      getter closing_tag_position

      property? in_component : Bool = false

      def initialize(@closing_tag_position : Parser::Location?,
                     @attributes : Array(HtmlAttribute),
                     @comments : Array(Comment),
                     @styles : Array(HtmlStyle),
                     @from : Parser::Location,
                     @children : Array(Node),
                     @to : Parser::Location,
                     @file : Parser::File,
                     @ref : Variable?,
                     @tag : Variable)
      end
    end
  end
end
