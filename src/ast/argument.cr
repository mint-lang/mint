module Mint
  class Ast
    class Argument < Node
      getter type, name, default

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @default : Node?,
                     @name : Variable,
                     @type : Node)
      end
    end
  end
end
