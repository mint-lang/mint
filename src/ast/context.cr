module Mint
  class Ast
    class Context < Node
      getter comment, type, name

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @name : Variable,
                     @type : Node)
      end
    end
  end
end
