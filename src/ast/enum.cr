module Mint
  class Ast
    class Enum < Node
      getter options, name, comments, comment, parameters

      def initialize(@parameters : Array(TypeVariable),
                     @options : Array(EnumOption),
                     @comments : Array(Comment),
                     @comment : Comment?,
                     @name : TypeId,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
