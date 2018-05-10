module Mint
  class Ast
    class ModuleAccess < Node
      getter variable, name

      def initialize(@variable : Variable,
                     @name : String,
                     @from : Int32,
                     @input : Data,
                     @to : Int32)
      end
    end
  end
end
