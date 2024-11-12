module Mint
  class Ast
    class Get < Node
      getter comment, name, body, type

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @name : Variable,
                     @body : Block,
                     @type : Node?)
      end
    end
  end
end
