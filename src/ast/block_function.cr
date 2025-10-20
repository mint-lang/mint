module Mint
  class Ast
    class BlockFunction < Node
      getter arguments, body, type

      def initialize(@arguments : Array(Argument),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @type : Node?,
                     @body : Block)
      end
    end
  end
end
