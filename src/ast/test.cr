module Mint
  class Ast
    class Test < Node
      getter name, expression

      def initialize(@name : StringLiteral,
                     @expression : Block,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
