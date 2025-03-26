module Mint
  class Ast
    class RecordDestructuring < Node
      getter fields

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @fields : Array(Field),
                     @file : Parser::File)
      end
    end
  end
end
