module Mint
  class Ast
    class CssNestedAt < Node
      getter content, body, name

      def initialize(@file : Parser::File,
                     @body : Array(Node),
                     @content : String,
                     @name : String,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
