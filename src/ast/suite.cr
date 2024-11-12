module Mint
  class Ast
    class Suite < Node
      getter constants, functions, comments, tests, name

      def initialize(@constants : Array(Constant),
                     @functions : Array(Function),
                     @comments : Array(Comment),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @name : StringLiteral,
                     @file : Parser::File,
                     @tests : Array(Test))
      end
    end
  end
end
