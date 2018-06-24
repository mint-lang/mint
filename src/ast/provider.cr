module Mint
  class Ast
    class Provider < Node
      getter subscription, functions, name, comment, comments

      def initialize(@functions : Array(Function),
                     @comments : Array(Comment),
                     @subscription : String,
                     @comment : Comment?,
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
