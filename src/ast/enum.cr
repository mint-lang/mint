module Mint
  class Ast
    class Enum < Node
      getter options, name, comments, comment

      def initialize(@options : Array(EnumOption),
                     @comments : Array(Comment),
                     @comment : Comment?,
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
