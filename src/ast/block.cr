module Mint
  class Ast
    class Block < Node
      getter expressions, fallback

      def initialize(@expressions : Array(Node),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @fallback : Node?)
      end
    end
  end
end
