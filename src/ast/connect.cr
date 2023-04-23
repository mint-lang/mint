module Mint
  class Ast
    class Connect < Node
      getter keys, store

      def initialize(@keys : Array(ConnectVariable),
                     @store : TypeId,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
