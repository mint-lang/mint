module Mint
  class Ast
    class Js < Node
      getter value, type

      def initialize(@value : Array(String | Interpolation),
                     @file : Parser::File,
                     @from : Int64,
                     @type : Node?,
                     @to : Int64)
      end
    end
  end
end
