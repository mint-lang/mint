module Mint
  class Ast
    class Emit < Node
      property signal : Signal? = nil
      getter expression

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @expression : Node)
      end
    end
  end
end
