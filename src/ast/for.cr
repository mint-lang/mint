module Mint
  class Ast
    class For < Node
      getter subject, body, arguments, condition

      def initialize(@arguments : Array(Node),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @condition : Block?,
                     @subject : Node,
                     @body : Block)
      end
    end
  end
end
