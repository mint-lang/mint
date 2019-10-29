module Mint
  class Ast
    class Interpolation < Node
      getter expression

      def initialize(@expression : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
