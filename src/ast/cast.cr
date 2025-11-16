module Mint
  class Ast
    class Cast < Node
      getter expression, type

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @expression : Node,
                     @type : Type)
      end
    end
  end
end
