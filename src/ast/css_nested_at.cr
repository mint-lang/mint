module Mint
  class Ast
    class CssNestedAt < Node
      getter content, body, name

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @body : Array(Node),
                     @content : String,
                     @name : String)
      end
    end
  end
end
