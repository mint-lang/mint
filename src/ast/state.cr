module Mint
  class Ast
    class State < Node
      getter default, type, name

      def initialize(@default : Expression,
                     @name : Variable,
                     @input : Data,
                     @from : Int32,
                     @type : Type,
                     @to : Int32)
      end
    end
  end
end
