module Mint
  class Ast
    class HereDocument < Node
      getter value, token, modifier, highlight

      def initialize(@value : Array(String | Interpolation),
                     @file : Parser::File,
                     @highlight : Bool?,
                     @modifier : Char,
                     @token : String,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
