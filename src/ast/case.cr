module Mint
  class Ast
    class Case < Node
      getter branches, condition, comments

      def initialize(@branches : Array(CaseBranch),
                     @comments : Array(Comment),
                     @file : Parser::File,
                     @condition : Node,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
