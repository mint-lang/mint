module Mint
  class Ast
    class Call < Node
      getter arguments, expression, safe

      property piped, partially_applied

      def initialize(@arguments : Array(Expression),
                     @partially_applied : Bool,
                     @expression : Expression,
                     @piped : Bool,
                     @input : Data,
                     @from : Int32,
                     @safe : Bool,
                     @to : Int32)
      end
    end
  end
end
