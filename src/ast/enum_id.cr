module Mint
  class Ast
    class EnumId < Node
      getter option, name, expressions

      def initialize(@expressions : Array(Expression),
                     @option : TypeId,
                     @name : TypeId?,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
