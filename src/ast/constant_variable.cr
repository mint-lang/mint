module Mint
  class Ast
    class ConstantVariable < Node
      getter name

      def initialize(@name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
