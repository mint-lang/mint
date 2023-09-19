module Mint
  class Ast
    class Suite < Node
      getter tests, name, comments, constants, functions

      def initialize(@constants : Array(Constant),
                     @functions : Array(Function),
                     @comments : Array(Comment),
                     @name : StringLiteral,
                     @tests : Array(Test),
                     @file : Parser::File,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
