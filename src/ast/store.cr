module Mint
  class Ast
    class Store < Node
      getter states, functions, name, gets, comment, comments, constants

      def initialize(@functions : Array(Function),
                     @constants : Array(Constant),
                     @comments : Array(Comment),
                     @states : Array(State),
                     @comment : Comment?,
                     @gets : Array(Get),
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      def owns?(node)
        {functions, constants, states, gets}.any? &.includes?(node)
      end
    end
  end
end
