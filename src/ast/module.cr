module Mint
  class Ast
    class Module < Node
      getter name, functions, comment, comments

      def initialize(@functions : Array(Function),
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
