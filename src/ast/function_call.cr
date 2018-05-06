module Mint
  class Ast
    class FunctionCall < Node
      getter arguments, function

      property piped

      def initialize(@arguments : Array(Expression),
                     @function : Variable,
                     @input : Data,
                     @piped : Bool,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
