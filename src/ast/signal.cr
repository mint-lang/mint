module Mint
  class Ast
    class Signal < Node
      getter block, comment, type, name

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @name : Variable,
                     @block : Block,
                     @type : Type)
      end
    end
  end
end
