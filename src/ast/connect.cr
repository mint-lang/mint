module Mint
  class Ast
    class Connect < Node
      getter keys, store

      def initialize(@keys : Array(ConnectVariable),
                     @file : Parser::File,
                     @from : Int64,
                     @to : Int64,
                     @store : Id)
      end
    end
  end
end
