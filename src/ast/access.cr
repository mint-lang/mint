module Mint
  class Ast
    class Access < Node
      getter field, lhs, safe

      def initialize(@field : Variable,
                     @lhs : Expression,
                     @safe : Bool,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
