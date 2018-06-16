module Mint
  class Ast
    class Alias < Node
      getter name, types

      def initialize(@types : Array(Type),
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
