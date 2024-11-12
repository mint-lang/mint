module Mint
  class Ast
    class CssFontFace < Node
      getter definitions

      def initialize(@definitions : Array(Node),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File)
      end
    end
  end
end
