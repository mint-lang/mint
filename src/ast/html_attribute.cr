module Mint
  class Ast
    class HtmlAttribute < Node
      getter value, name

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @name : Variable,
                     @value : Node)
      end
    end
  end
end
