module Mint
  class Ast
    class SignalValue < Node
      getter expression

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @expression : Node)
      end
    end
  end
end
