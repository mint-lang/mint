module Mint
  class Ast
    class Argument < Node
      getter type, name

      def initialize(@type : TypeOrVariable,
                     @name : Variable,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
