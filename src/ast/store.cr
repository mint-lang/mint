module Mint
  class Ast
    class Store < Node
      getter properties, functions, name

      def initialize(@properties : Array(Property),
                     @functions : Array(Function),
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
