module Mint
  class Ast
    class RecordField < Node
      getter key, value

      def initialize(@value : Expression,
                     @key : Variable,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
