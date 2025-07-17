module Mint
  class Ast
    class Access < Node
      getter field, expression, type

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @expression : Node,
                     @field : Variable)
      end
    end
  end
end
