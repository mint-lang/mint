module Mint
  class Ast
    class CssKeyframes < Node
      getter selectors, name

      def initialize(@selectors : Array(Node),
                     @file : Parser::File,
                     @name : String,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
