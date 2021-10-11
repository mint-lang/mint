module Mint
  class Ast
    class Access < Node
      getter field, lhs
      getter? safe

      def initialize(@field : Variable,
                     @lhs : Expression,
                     @input : Data,
                     @from : Int32,
                     @safe : Bool,
                     @to : Int32)
      end
    end
  end
end
