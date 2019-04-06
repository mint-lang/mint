module Mint
  class Ast
    class Call < Node
      getter arguments, expression

      property piped

      def initialize(@arguments : Array(Expression),
                     @expression : Expression,
                     @piped : Bool,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
