module Mint
  class Ast
    class RecordConstructor < Node
      getter name, arguments

      def initialize(@arguments : Array(Expression),
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
