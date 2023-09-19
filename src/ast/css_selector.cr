module Mint
  class Ast
    class CssSelector < Node
      getter selectors, body

      def initialize(@selectors : Array(String),
                     @file : Parser::File,
                     @body : Array(Node),
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
