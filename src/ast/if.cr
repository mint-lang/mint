module Mint
  class Ast
    class If < Node
      getter condition, branches

      alias Branches = Tuple(Block, Block) |
                       Tuple(Block, Nil) |
                       Tuple(Block, If)

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @branches : Branches,
                     @condition : Node)
      end
    end
  end
end
