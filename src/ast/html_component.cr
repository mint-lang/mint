module Mint
  class Ast
    class HtmlComponent < Node
      getter attributes, component, children, comments, ref
      getter closing_tag_position

      property component_node : Ast::Component? = nil
      property fallback_node : Ast::Node? = nil
      property ancestor : Ast::Node? = nil

      def initialize(@closing_tag_position : Parser::Location?,
                     @attributes : Array(HtmlAttribute),
                     @comments : Array(Comment),
                     @from : Parser::Location,
                     @children : Array(Node),
                     @to : Parser::Location,
                     @file : Parser::File,
                     @ref : Variable?,
                     @component : Id)
      end
    end
  end
end
