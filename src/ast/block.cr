module Mint
  class Ast
    class Block < Node
      getter expressions

      def initialize(@expressions : Array(Node),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File)
      end
    end
  end
end
