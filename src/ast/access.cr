module Mint
  class Ast
    class Access < Node
      getter field, lhs

      def initialize(@field : Variable,
                     @lhs : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
