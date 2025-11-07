module Mint
  class Ast
    class Tags < Node
      getter options

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @options : Array(Tag),
                     @file : Parser::File)
      end
    end
  end
end
