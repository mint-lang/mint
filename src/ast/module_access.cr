module Mint
  class Ast
    class ModuleAccess < Node
      getter variable, name, constant

      def initialize(@variable : Variable,
                     @name : String,
                     @from : Int32,
                     @input : Data,
                     @to : Int32,
                     @constant : Bool = false)
      end
    end
  end
end
