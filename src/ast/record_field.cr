module Mint
  class Ast
    class RecordField < Node
      getter key, value, comment

      def initialize(@value : Expression,
                     @comment : Comment?,
                     @key : Variable,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
