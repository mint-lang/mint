module Mint
  class Ast
    class Env < Node
      getter name

      def initialize(@name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
