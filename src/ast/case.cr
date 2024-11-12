module Mint
  class Ast
    class Case < Node
      getter branches, condition, comments

      def initialize(@branches : Array(CaseBranch),
                     @comments : Array(Comment),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @condition : Node)
      end
    end
  end
end
