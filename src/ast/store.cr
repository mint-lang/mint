module Mint
  class Ast
    class Store < Node
      getter properties, functions, name, gets, comment

      def initialize(@properties : Array(Property),
                     @functions : Array(Function),
                     @comment : Comment?,
                     @gets : Array(Get),
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
