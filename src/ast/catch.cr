module Mint
  class Ast
    class Catch < Node
      getter variable, expression, type

      def initialize(@expression : Expression,
                     @variable : Variable,
                     @type : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
