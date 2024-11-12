module Mint
  class Ast
    class Module < Node
      getter functions, constants, comments, comment, name

      def initialize(@functions : Array(Function),
                     @constants : Array(Constant),
                     @comments : Array(Comment),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @name : Id)
      end
    end
  end
end
