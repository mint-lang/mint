module Mint
  class Ast
    class Connect < Node
      getter keys, store

      def initialize(@keys : Array(ConnectVariable),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @store : Id)
      end
    end
  end
end
