module Mint
  class Ast
    class CssFontFace < Node
      getter definitions

      def initialize(@definitions : Array(Node),
                     @file : Parser::File,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
