module Mint
  class Ast
    class Suite < Node
      getter tests, name, comments

      def initialize(@comments : Array(Comment),
                     @name : StringLiteral,
                     @tests : Array(Test),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
