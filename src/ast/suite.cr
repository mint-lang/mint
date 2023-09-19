module Mint
  class Ast
    class Suite < Node
      getter tests, name, comments, constants

      def initialize(@constants : Array(Constant),
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
