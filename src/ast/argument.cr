module Mint
  class Ast
    class Argument < Node
      getter type, name, default

      def initialize(@type : TypeOrVariable,
                     @name : Variable,
                     @default : Node?,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
