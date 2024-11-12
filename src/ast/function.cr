module Mint
  class Ast
    class Function < Node
      getter arguments, comment, name, type, body

      def initialize(@arguments : Array(Argument),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @name : Variable,
                     @type : Node?,
                     @body : Block)
      end
    end
  end
end
