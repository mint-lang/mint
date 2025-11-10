module Mint
  class Ast
    class Call < Node
      getter arguments, expression, await

      def initialize(@arguments : Array(Field),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @expression : Node,
                     @await : Bool)
      end
    end
  end
end
