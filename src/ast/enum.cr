module Mint
  class Ast
    class Enum < Node
      getter options, name, comments

      def initialize(@options : Array(EnumOption),
                     @comments : Array(Comment),
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
