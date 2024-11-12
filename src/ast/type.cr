module Mint
  class Ast
    class Type < Node
      getter parameters, name

      def initialize(@parameters : Array(Node),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @name : Id)
      end
    end
  end
end
