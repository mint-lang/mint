module Mint
  class Ast
    class Route < Node
      getter expression, arguments, url, await

      def initialize(@arguments : Array(Argument),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @expression : Block,
                     @await : Bool,
                     @url : String)
      end
    end
  end
end
