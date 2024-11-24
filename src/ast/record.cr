module Mint
  class Ast
    class Record < Node
      getter fields, comment

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @fields : Array(Field),
                     @file : Parser::File,
                     @comment : Comment?)
      end
    end
  end
end
