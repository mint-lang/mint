module Mint
  class Ast
    class Module < Node
      getter name, functions

      def initialize(@functions : Array(Function),
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
