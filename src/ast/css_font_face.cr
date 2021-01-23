module Mint
  class Ast
    class CssFontFace < Node
      getter definitions

      def initialize(@definitions : Array(Node),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
