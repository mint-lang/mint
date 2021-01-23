module Mint
  class Ast
    class Constant < Node
      getter name, value, comment

      def initialize(@value : Expression,
                     @comment : Comment?,
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
