module Mint
  class Ast
    class CssDefinition < Node
      getter name, value

      def initialize(@value : Array(String | Node),
                     @file : Parser::File,
                     @name : String,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
