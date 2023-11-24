module Mint
  class Ast
    class Store < Node
      getter functions, constants, comments, comment, states, gets, name

      def initialize(@functions : Array(Function),
                     @constants : Array(Constant),
                     @comments : Array(Comment),
                     @states : Array(State),
                     @file : Parser::File,
                     @comment : Comment?,
                     @gets : Array(Get),
                     @from : Int64,
                     @to : Int64,
                     @name : Id)
      end
    end
  end
end
