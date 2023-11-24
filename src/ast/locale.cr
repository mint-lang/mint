module Mint
  class Ast
    class Locale < Node
      getter language, fields, comment

      def initialize(@fields : Array(Field),
                     @file : Parser::File,
                     @comment : Comment?,
                     @language : String,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
