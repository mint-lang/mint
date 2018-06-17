module Mint
  class Ast
    class Module < Node
      getter name, functions, comment

      def initialize(@functions : Array(Function),
                     @comment : Comment?,
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
