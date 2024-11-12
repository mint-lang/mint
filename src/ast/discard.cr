module Mint
  class Ast
    class Discard < Node
      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File)
      end
    end
  end
end
