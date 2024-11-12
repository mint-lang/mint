module Mint
  class Ast
    class HereDocument < Node
      getter highlight, modifier, token, value

      def initialize(@value : Array(String | Interpolation),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @highlight : Bool?,
                     @modifier : Char,
                     @token : String)
      end
    end
  end
end
