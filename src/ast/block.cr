module Mint
  class Ast
    class Block < Node
      getter statements

      def initialize(@statements : Array(Node),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
