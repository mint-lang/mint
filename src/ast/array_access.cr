module Mint
  class Ast
    class ArrayAccess < Node
      getter index, lhs

      def initialize(@index : (Int64 | Expression),
                     @lhs : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
