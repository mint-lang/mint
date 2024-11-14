module Mint
  class Ast
    class Property < Node
      getter default, comment, type, name

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @default : Node?,
                     @name : Variable,
                     @type : Type?)
      end
    end
  end
end
