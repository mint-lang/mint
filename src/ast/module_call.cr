module Mint
  class Ast
    class ModuleCall < Node
      getter arguments, name, function

      property piped

      def initialize(@arguments : Array(Expression),
                     @function : Variable,
                     @name : String,
                     @piped : Bool,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
