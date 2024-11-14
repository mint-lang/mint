module Mint
  class Ast
    class CssSelector < Node
      getter selectors, body

      def initialize(@selectors : Array(String),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @body : Array(Node))
      end
    end
  end
end
