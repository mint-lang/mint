module Mint
  class Ast
    class Provide < Node
      getter name, expression

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @expression : Node,
                     @name : Id)
      end
    end
  end
end
