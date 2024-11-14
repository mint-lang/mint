module Mint
  class Ast
    class Style < Node
      getter arguments, body, name

      def initialize(@arguments : Array(Argument),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @body : Array(Node),
                     @name : Variable)
      end
    end
  end
end
