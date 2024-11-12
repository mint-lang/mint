module Mint
  class Ast
    class Access < Node
      getter field, expression, type

      # TODO: Remove in 0.21.0.
      enum Type
        DoubleColon
        Colon
        Dot
      end

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @expression : Node,
                     @field : Variable,
                     @type : Type)
      end
    end
  end
end
