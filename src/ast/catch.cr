module Mint
  class Ast
    class Catch < Node
      getter variable, expression, type, head_comment, tail_comment

      def initialize(@expression : Expression,
                     @head_comment : Comment?,
                     @tail_comment : Comment?,
                     @variable : Variable,
                     @type : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
