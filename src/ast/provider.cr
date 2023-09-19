module Mint
  class Ast
    class Provider < Node
      getter subscription, functions, name, comment, comments
      getter gets, states, constants

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
