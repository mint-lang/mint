module Mint
  class Ast
    class Js < Node
      getter value, type

      def initialize(@value : Array(String | Interpolation),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @type : Node?)
      end
    end
  end
end
