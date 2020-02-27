module Mint
  class Ast
    class WhereStatement < Node
      getter target, expression

      def initialize(@target : Node,
                     @expression : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
