module Mint
  class Ast
    class CssKeyframes < Node
      getter selectors, name

      def initialize(@selectors : Array(Node),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @name : String)
      end
    end
  end
end
