module Mint
  class Ast
    class ConnectVariable < Node
      getter variable, name

      def initialize(@variable : Variable,
                     @name : Variable?,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
