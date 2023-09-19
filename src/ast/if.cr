module Mint
  class Ast
    class If < Node
      getter condition, branches

      alias Branches = Tuple(Block, Block) |
                       Tuple(Block, Nil) |
                       Tuple(Block, If)

      def initialize(@branches : Branches,
                     @file : Parser::File,
                     @condition : Node,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
