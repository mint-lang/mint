module Mint
  class Ast
    class Styles < Node
      getter name, comment, comments, styles

      def initialize(@comments : Array(Comment),
                     @styles : Array(Style),
                     @comment : Comment?,
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
