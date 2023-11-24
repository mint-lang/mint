module Mint
  class Ast
    class Route < Node
      getter expression, arguments, url, await

      def initialize(@arguments : Array(Argument),
                     @file : Parser::File,
                     @expression : Block,
                     @from : Int64,
                     @await : Bool,
                     @url : String,
                     @to : Int64)
      end
    end
  end
end
