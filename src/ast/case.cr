module Mint
  class Ast
    # TODO: Change condition to a statment like with if.
    class Case < Node
      getter branches, condition, comments, await

      def initialize(@branches : Array(CaseBranch),
                     @comments : Array(Comment),
                     @file : Parser::File,
                     @condition : Node,
                     @await : Bool,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
