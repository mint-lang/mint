module Mint
  class Ast
    class Call < Node
      getter arguments, expression

      property? partially_applied

      def initialize(@arguments : Array(Expression),
                     @partially_applied : Bool,
                     @expression : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
