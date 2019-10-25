module Mint
  class Ast
    class Style < Node
      getter name, body, arguments

      def initialize(@arguments : Array(Argument),
                     @body : Array(Node),
                     @name : Variable,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
