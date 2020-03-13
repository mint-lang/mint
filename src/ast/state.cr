module Mint
  class Ast
    class State < Node
      getter default, type, name, comment

      def initialize(@default : Expression,
                     @comment : Comment?,
                     @name : Variable,
                     @input : Data,
                     @from : Int32,
                     @type : Type?,
                     @to : Int32)
      end
    end
  end
end
