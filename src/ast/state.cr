module Mint
  class Ast
    class State < Node
      getter default, comment, type, name

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @name : Variable,
                     @default : Node,
                     @type : Type?)
      end
    end
  end
end
