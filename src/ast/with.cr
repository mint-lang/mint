module Mint
  class Ast
    class With < Node
      getter body, name

      def initialize(@body : Expression,
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
