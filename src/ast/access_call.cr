module Mint
  class Ast
    class AccessCall < Node
      getter arguments, access

      property piped

      def initialize(@arguments : Array(Expression),
                     @access : Access,
                     @piped : Bool,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
