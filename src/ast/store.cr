module Mint
  class Ast
    class Store < Node
      getter functions, constants, comments, signals, comment, states
      getter gets, name

      def initialize(@functions : Array(Function),
                     @constants : Array(Constant),
                     @comments : Array(Comment),
                     @signals : Array(Signal),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @states : Array(State),
                     @file : Parser::File,
                     @comment : Comment?,
                     @gets : Array(Get),
                     @name : Id)
      end
    end
  end
end
