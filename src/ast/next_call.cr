module Mint
  class Ast
    class NextCall < Node
      getter data

      def initialize(@data : Record,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
