module Mint
  class Ast
    class StateSetter < Node
      getter entity, state

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @state : Variable,
                     @entity : Id?)
      end
    end
  end
end
