module Mint
  class Ast
    class Get < Node
      getter name, body, type

      def initialize(@body : Expression,
                     @name : Variable,
                     @input : Data,
                     @from : Int32,
                     @type : Type,
                     @to : Int32)
      end
    end
  end
end
