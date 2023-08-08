module Mint
  class Ast
    class Type < Node
      getter name, parameters

      def initialize(@parameters : Array(Node),
                     @file : Parser::File,
                     @from : Int64,
                     @to : Int64,
                     @name : Id)
      end
    end
  end
end
