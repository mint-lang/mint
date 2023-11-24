module Mint
  class Ast
    class Provider < Node
      getter subscription, functions, constants, comments
      getter comment, states, gets, name

      def initialize(@functions : Array(Function),
                     @constants : Array(Constant),
                     @comments : Array(Comment),
                     @states : Array(State),
                     @subscription : Id,
                     @file : Parser::File,
                     @comment : Comment?,
                     @gets : Array(Get),
                     @name : Id,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
