module Mint
  class Ast
    class Locale < Node
      getter language, fields, comment

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @fields : Array(Field),
                     @file : Parser::File,
                     @comment : Comment?,
                     @language : String)
      end
    end
  end
end
