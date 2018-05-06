module Mint
  class Ast
    class ModuleCall < Node
      getter arguments, name, function

      property piped

      def initialize(@arguments : Array(Expression),
                     @function : Variable,
                     @name : String,
                     @input : Data,
                     @from : Int32,
                     @piped : Bool,
                     @to : Int32)
      end
    end
  end
end
