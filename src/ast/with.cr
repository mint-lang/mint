module Mint
  class Ast
    class With < Node
      getter items, body

      def initialize(@from : Parser::Location,
                     @items : Array(WithItem),
                     @to : Parser::Location,
                     @file : Parser::File,
                     @body : Block)
      end
    end
  end
end
