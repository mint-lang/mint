module Mint
  class Ast
    class InlineFunction < Node
      getter arguments, body, type

      def initialize(@arguments : Array(Argument),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @body : Block,
                     @type : Node?)
      end
    end
  end
end
