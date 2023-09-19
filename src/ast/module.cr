module Mint
  class Ast
    class Module < Node
      getter name, functions, comment, comments, constants

      def initialize(@functions : Array(Function),
                     @constants : Array(Constant),
                     @comments : Array(Comment),
                     @file : Parser::File,
                     @comment : Comment?,
                     @from : Int64,
                     @to : Int64,
                     @name : Id)
      end
    end
  end
end
