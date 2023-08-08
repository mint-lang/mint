module Mint
  class Ast
    class ConnectVariable < Node
      getter target, name

      def initialize(@file : Parser::File,
                     @target : Variable?,
                     @name : Variable,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
