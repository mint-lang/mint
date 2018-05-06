module Mint
  class Ast
    class CssSelector < Node
      getter selectors, definitions

      def initialize(@definitions : Array(CssDefinition),
                     @selectors : Array(String),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
