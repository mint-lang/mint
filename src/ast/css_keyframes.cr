module Mint
  class Ast
    class CssKeyframes < Node
      getter selectors, name

      def initialize(@selectors : Array(Node),
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
