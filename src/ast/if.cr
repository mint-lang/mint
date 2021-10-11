module Mint
  class Ast
    class If < Node
      getter condition, branches

      alias Branches = Tuple(Array(CssDefinition), Array(CssDefinition)) |
                       Tuple(Array(CssDefinition), Nil) |
                       Tuple(Array(CssDefinition), If) |
                       Tuple(Block, Block)

      def initialize(@branches : Branches,
                     @condition : Node,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
