module Mint
  class Ast
    class Dbg < Node
      getter expression
      getter? bang

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @expression : Node?,
                     @bang : Bool)
      end
    end
  end
end
