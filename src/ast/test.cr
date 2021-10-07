module Mint
  class Ast
    class Test < Node
      getter name, expression

      def initialize(@expression : Expression,
                     @name : StringLiteral,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
