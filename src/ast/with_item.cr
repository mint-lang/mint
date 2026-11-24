module Mint
  class Ast
    class WithItem < Node
      getter name, type

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @name : Variable,
                     @type : Node)
      end
    end
  end
end
