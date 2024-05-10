module Mint
  class Ast
    class Provider < Node
      getter subscription, functions, constants, comments
      getter comment, states, gets, name, signals

      def initialize(@functions : Array(Function),
                     @constants : Array(Constant),
                     @comments : Array(Comment),
                     @signals : Array(Signal),
                     @states : Array(State),
                     @file : Parser::File,
                     @comment : Comment?,
                     @subscription : Id,
                     @gets : Array(Get),
                     @name : Id,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
